# debian-rdfox

Runs the RDFox triple store.

## License

Get a license file from [Oxford Seantic Tech](https://www.oxfordsemantic.tech/) and store it as `RDFox.lic`
in your current directory.

## Run

```
local_workdir=$(pwd)
rdfox_license="${local_workdir}/RDFox.lic"

docker run \
  --interactive --tty --rm \
  --mount type=bind,source=${rdfox_license},target=/home/ekgprocess/rdfox/RDFox.lic \
  --mount type=bind,source=${local_workdir},target=/home/ekgprocess/workdir \
  --workdir="/home/ekgprocess/workdir" \
  ekgf/debian-rdfox
```

## RDFox

- [Introduction](https://docs.oxfordsemantic.tech/introduction.html)
- [Semantic Web Page](https://www.w3.org/2001/sw/wiki/RDFox)
- [Paper](http://iswc2015.semanticweb.org/sites/iswc2015.semanticweb.org/files/93670001.pdf)
- [Old Video - RDFox — A Modern Materialisation-Based RDF System](https://www.youtube.com/watch?v=NAEFLsRN4Zw)