package main

import (
	"context"
	"os"

	"github.com/exaring/otelpgx"
	"github.com/jackc/pgx/v5/pgxpool"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracehttp"
	"go.opentelemetry.io/otel/exporters/stdout/stdouttrace"
	"go.opentelemetry.io/otel/sdk/resource"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
	semconv "go.opentelemetry.io/otel/semconv/v1.26.0"
)

func main() {
	ctx := context.Background()

	opts := []sdktrace.TracerProviderOption{
		sdktrace.WithSampler(sdktrace.AlwaysSample()),
		sdktrace.WithResource(
			resource.NewWithAttributes(
				semconv.SchemaURL,
				semconv.ServiceNameKey.String("pgx-otel"),
				semconv.ServiceVersion("v0.0.0"),
			),
		),
	}

	otelEndpoint := os.Getenv("OTEL_EXPORTER_OTLP_ENDPOINT")
	if otelEndpoint == "" {
		exporter, err := stdouttrace.New(stdouttrace.WithPrettyPrint())
		if err != nil {
			panic(err)
		}
		opts = append(opts, sdktrace.WithBatcher(exporter))
	} else {
		otelClient := otlptracehttp.NewClient()
		exporter, err := otlptrace.New(ctx, otelClient)
		if err != nil {
			panic(err)
		}
		opts = append(opts, sdktrace.WithBatcher(exporter))
	}

	tp := sdktrace.NewTracerProvider(opts...)
	otel.SetTracerProvider(tp)

	defer func() {
		if err := tp.ForceFlush(ctx); err != nil {
			panic(err)
		}

		if err := tp.Shutdown(ctx); err != nil {
			panic(err)
		}
	}()

	if err := run(tp); err != nil {
		panic(err)
	}
}

func run(tp *sdktrace.TracerProvider) error {
	ctx := context.Background()

	tracer := otel.Tracer("pgx-otel-tracer")

	ctx, span := tracer.Start(ctx, "run")
	defer span.End()

	url := "postgres://usr:pw@localhost:5432/db?sslmode=disable"
	cfg, err := pgxpool.ParseConfig(url)
	if err != nil {
		return err
	}

	cfg.ConnConfig.Tracer = otelpgx.NewTracer(otelpgx.WithTracerProvider(tp))

	conn, err := pgxpool.NewWithConfig(ctx, cfg)
	if err != nil {
		return err
	}
	defer conn.Close()

	if err := conn.Ping(ctx); err != nil {
		return err
	}

	row, err := conn.Query(ctx, "SELECT 1")
	if err != nil {
		return err
	}
	defer row.Close()

	return nil
}
