# Changelog

## [0.1.1](https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE/compare/v0.1.0...v0.1.1) (2026-07-12)


### Features

* Implementar módulo EC2 con zero trust ([c02728c](https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE/commit/c02728ca362bda4dee04e732fe0fd10e9e0aea41))
* Implementar módulo S3 con zero trust, ciclo de vida y cifrado por defecto ([48da101](https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE/commit/48da101838f31ae3adae6a1db9f8aa046f8a5a8c))


### Bug Fixes

* agregar abort_incomplete_multipart_upload en módulo s3 para cumplir con ckv_aws_300 ([ec17253](https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE/commit/ec172534ce621b9741c4e0134d1b305048693602))
* corregir sintaxis de supresiones checkov y agregar ciclo de vida s3 ([0ccd22b](https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE/commit/0ccd22bc338b1479cee2046bd236d5223e2f9163))
* corregir sintaxis de supresiones checkov, main y agregar ciclo de vida s3 ([1d07536](https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE/commit/1d07536613c13d73419526f0888271c009244895))
* suprimir alertas checkov de ebs y monitorizacion en EC2 con Cloudwatch ([78eb2db](https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE/commit/78eb2db7f58fbe3de5cc56a70c42d10c6f4d889c))
* suprimir alertas checkov en la configuración del bucket S3 para evitar costos innecesarios ([4eecff6](https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE/commit/4eecff630e5b1c23354c0585aa61ef90dd253e93))

## 0.1.0 (2026-07-12)


### Features

* Implementar módulo VPC con AZ dinámicas y arquitectura zero trust ([79e7078](https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE/commit/79e7078cddf8d52471dd9b43b5f49d203b5f3852))
* Implementar módulos VPC con data source dinámicos y supresiones de seguridad documentadas ([a7537a6](https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE/commit/a7537a6efa6e25655bd8eee20bd63f00828618da))
