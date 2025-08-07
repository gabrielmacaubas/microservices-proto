# Defina seu nome de usuário e e-mail do GitHub
$GITHUB_USERNAME = "gabrielmacaubas"
$GITHUB_EMAIL = "gabrielmacaubas@outlook.com"

$SERVICE_NAME = "payment"
$RELEASE_VERSION = "v1.2.3"

# Instala o plugin do Protobuf para Go
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

# Garante que o GOPATH/bin está no PATH (válido apenas para esta sessão)
$env:PATH += ";" + (go env GOPATH) + "\bin"

Write-Host "Generating Go source code"
New-Item -ItemType Directory -Force -Path "golang" | Out-Null

protoc --go_out=./golang `
  --go_opt=paths=source_relative `
  --go-grpc_out=./golang `
  --go-grpc_opt=paths=source_relative `
  .\$SERVICE_NAME\*.proto

Write-Host "Generated Go source code files"
Get-ChildItem -Path "golang\$SERVICE_NAME"

Set-Location -Path "golang\$SERVICE_NAME"

go mod init "github.com/$GITHUB_USERNAME/microservices-proto/golang/$SERVICE_NAME" -ErrorAction SilentlyContinue
go mod tidy

# Git commit e push (descomente se quiser usar)
# git config --global user.email $GITHUB_EMAIL
# git config --global user.name $GITHUB_USERNAME
# git add .
# git commit -am "proto update"
# git push -u origin HEAD

# Atualização da tag (descomente se quiser usar)
# git tag -d "ch03/listing_3.2/golang/$SERVICE_NAME/$RELEASE_VERSION"
# git push --delete origin "ch03/listing_3.2/golang/$SERVICE_NAME/$RELEASE_VERSION"
# git tag -fa "ch03/listing_3.2/golang/$SERVICE_NAME/$RELEASE_VERSION" -m "ch03/listing_3.2/golang/$SERVICE_NAME/$RELEASE_VERSION"
# git push origin "refs/tags/ch03/listing_3.2/golang/$SERVICE_NAME/$RELEASE_VERSION"
