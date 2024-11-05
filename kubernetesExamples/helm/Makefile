values := $(wildcard values-*.yaml)
helm-chart.yaml: helmfile.yaml $(values)
	helmfile template > $@