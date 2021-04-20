version ?= $(shell git describe --always)

image=densavchenko/antares:$(version)
image_latest=densavchenko/antares:latest

run: build
	docker run \
		-it \
		-u $(shell id -u) \
		-v /tmp/dev/log:/var/log/containers \
		-v /tmp/dev/workdir:/workdir/antares_environment/antares_output \
		--rm \
		-p 8010:8000 \
		--name dev-oda-antares \
		$(image) 

build:
	git submodule update --init
	docker build  -t $(image)  \
		.


push: build
	docker tag $(image) $(image_latest)
	docker push $(image_latest)
	docker push $(image)


submodule-diff:
	(for k in $(shell git submodule | awk '{print $$2}'); do (cd $$k; pwd; git diff); done)
