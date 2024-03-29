#!/usr/bin/env bash

set -eo pipefail

version=$1

echo "Generating CRDs for Prometheus operator $version..."

crds=(
    "alertmanagers"
    "alertmanagerconfigs"
    "podmonitors"
    "probes"
    "prometheuses"
    "prometheusrules"
    "servicemonitors"
    "thanosrulers"
)

baseUrl="https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$version/example/prometheus-operator-crd"

for crd in "${crds[@]}"; do
    echo "    $crd"
    curl --no-progress-meter "$baseUrl/monitoring.coreos.com_$crd.yaml" |
        tfk8s -o "$crd.tf" --strip
done

echo "Formatting..."
terraform fmt -list=false

echo "$version" > PROMETHEUS_VERSION
