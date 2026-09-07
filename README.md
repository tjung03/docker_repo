# Docker 이미지 제작과 서비스 구성 실습

Dockerfile로 서비스 이미지를 만들고, Docker Compose로 여러 컨테이너의 연결과 실행 설정을 구성한 실습 저장소입니다. 기본 명령부터 멀티 스테이지 빌드, 인증서를 사용하는 사설 Registry, HAProxy 설정까지 디렉터리별로 살펴볼 수 있습니다.

## 주요 구현

| 주제 | 구현 내용 | 코드 |
| --- | --- | --- |
| 빌드 환경과 실행 환경 분리 | Go 빌드 단계의 작업 디렉터리를 `scratch` 기반 실행 이미지로 복사 | [멀티 스테이지 빌드](05_MultiStage/Dockerfile) |
| 서비스 시작 과정 구성 | PHP-FPM을 시작한 뒤 Apache를 포그라운드로 실행하는 진입 스크립트 | [Apache·PHP](05_minpro2/) |
| 사설 이미지 저장소 | Registry의 TLS·htpasswd 인증, 저장 경로와 웹 UI 연결 설정 | [Registry](06_private-registry3/) · [Registry UI](06_registry-ui/) |
| 여러 서비스 연결 | MongoDB와 Mongo Express, PostgreSQL과 Adminer를 Compose로 구성 | [Compose 예제](07_compose/) |
| 요청 분산 설정 | HAProxy의 경로별 백엔드 선택과 round-robin 설정 | [HAProxy 구성](07_haproxy-compose/) |

## 코드 찾아보기

| 디렉터리 | 내용 |
| --- | --- |
| [05_RUN](05_RUN/) · [05_dockerfile](05_dockerfile/) | RUN·CMD·ENTRYPOINT와 명령 실행 방식 |
| [05_user](05_user/) · [05_workdir](05_workdir/) · [05_shellscript](05_shellscript/) | 실행 사용자, 작업 디렉터리, 시작 스크립트 |
| [05_ImageLayer](05_ImageLayer/) · [05_MultiStage](05_MultiStage/) | 이미지 레이어와 멀티 스테이지 빌드 |
| [05_minpro1](05_minpro1/) · [05_minpro2](05_minpro2/) · [05_minpro3](05_minpro3/) | FTP, Apache·PHP, WSGI 서비스 이미지 |
| [05_minpro4](05_minpro4/) · [05_python](05_python/) | Go 웹 앱과 Flask·MySQL 예제 |
| [06_private-registry3](06_private-registry3/) · [06_registry-ui](06_registry-ui/) | 인증·TLS를 사용하는 Registry와 웹 UI |
| [07_compose](07_compose/) · [07_compose-cmd](07_compose-cmd/) | 포트, 볼륨, 서비스 연결과 Compose 명령 실습 |
| [07_haproxy-compose](07_haproxy-compose/) · [07_haproxy-cmd](07_haproxy-cmd/) | HAProxy 백엔드 구성 예제 |

각 예제는 해당 디렉터리에서 개별적으로 실행합니다. `05_minpro4`는 Dockerfile에 명시된 HashiCorp의 `learn-go-webapp-demo` 예제를 가져와 이미지로 구성합니다.

## 실행해 보기

Docker Engine과 Docker Compose 플러그인이 설치된 환경에서 시작합니다.

```bash
git clone https://github.com/tjung03/docker_repo.git
cd docker_repo
docker version
docker compose version
```

### Dockerfile로 Nginx 이미지 만들기

[05_RUN/Dockerfile](05_RUN/Dockerfile)은 Ubuntu 24.04에 Nginx를 설치하고 포그라운드로 실행합니다. 저장소 루트에서 빌드합니다.

```bash
docker build -t nginx-lab ./05_RUN
docker run --rm -d --name nginx-lab -p 127.0.0.1:8082:80 nginx-lab
curl http://localhost:8082
docker stop nginx-lab
```

HTTP 응답으로 Nginx 페이지를 확인할 수 있습니다.

### Compose로 Nginx 실행하기

[07_compose/02_nginx](07_compose/02_nginx/)는 호스트의 8080 포트를 컨테이너의 80 포트에 연결합니다.

```bash
cd 07_compose/02_nginx
docker compose config
docker compose up -d
docker compose ps
curl http://localhost:8080
docker compose down
```

## 확장 실습의 실행 조건

| 예제 | 준비할 내용 |
| --- | --- |
| Registry | Compose와 `config.yml`에 지정된 인증서·개인 키·htpasswd 파일 및 저장 디렉터리 준비. 클라이언트에서 인증서를 신뢰하도록 설정 |
| HAProxy | 기본 Compose의 `web1`·`web2`·`web3`와 HAProxy 설정의 백엔드 호스트 이름을 일치시켜야 함. 설정에 포함된 정적 파일 백엔드는 별도 서비스 필요 |
| Flask·MySQL | `mysqldb` 이름으로 연결할 MySQL 필요. `/initdb`와 `/widgets` 모두 `inventory` 데이터베이스를 삭제하고 다시 생성하므로 전용 실습 DB 사용 |
| DB 관리 도구 | MongoDB·PostgreSQL 예제의 계정 설정은 실습용. 개인 실습 환경에 맞는 계정으로 준비 |

## 사용 기술과 버전

파일에 지정된 주요 이미지 태그는 다음과 같습니다.

| 용도 | 이미지·버전 |
| --- | --- |
| 기본 Dockerfile 실습 | `ubuntu:24.04`, CentOS Stream 9 계열 |
| 멀티 스테이지 빌드 | `golang:alpine` → `scratch` |
| Go 웹 앱 예제 | `golang:1.16` |
| Flask 예제 | `python:3.8-slim-buster`, Flask `3.0.3`, mysql-connector-python `9.0.0` |
| Registry | `registry:3` |
| HAProxy | `haproxytech/haproxy-alpine:2.7` |

Python 3.8과 HAProxy 2.7은 지원이 종료된 버전입니다. 지원 상태는 [Python 공식 릴리스 안내](https://www.python.org/downloads/release/python-3810/)와 [HAProxy 공식 문서](https://docs.haproxy.org/)에서 확인할 수 있습니다. `latest` 또는 버전을 생략한 이미지와 패키지는 빌드 시점에 따라 달라질 수 있습니다.
