# Ambiente de desenvolvimento em PHP

Ambiente básico para o desenvolmento de aplicações em PHP, este repositório possui os seguintes componentes:

- PHP-FPM 8.1
- Nginx 1.21.6
- Xdebug 3

### Dockerfile PHP-FPM

O Dockerfile do php-fpm possui um entrypoint que executa o comando 'composer install' sempre que o container for criado, se existir o arquivo composer.json e se a pasta vendor não existir.

### Dockerfile Nginx

O Dockerfile do nginx possui um entrypoint para substituir as variáveis de ambiente SERVER_NAME e DOCUMENT_ROOT. 

Se a variável de ambiente SERVER_NAME não estiver definida no docker-compose.yml o entrypoint irá definir a variável como 'localhost'.

O caminho da pasta da aplicação é /var/www/html nos containers do PHP-PHP e Nginx. A variável DOCUMENT_ROOT complementa o caminho da aplicação, caso precise mudar o caminho para public por exemplo. Se definir a variável como DOCUMENT_ROOT = public o entrypoint vai acrescentar o valor ao caminho da pasta ficando /var/www/html/public

### Xdebug com VsCode

- No VsCode vá em Arquivo -> Preferências -> Configurações. Habilite a opção 'Allow Breakpoints Everywhere'.
- Instale a extensão [Xdebug helper](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc)
- Clique no besouro com o botão direito e va em opções
- Selecione a opção others e coloque a chave como VSCODE (que é o mesmo valor que está configurado para o xdebug.idekey no dockerfile do php-fpm) e salve.
- No VsCode instale a extensão [PHP Debug](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug)

Arquivo de configuração do Xdebug no VsCode (launch.json):

```
{
  // Use o IntelliSense para saber mais sobre os atributos possíveis.
  // Focalizar para exibir as descrições dos atributos existentes.
  // Para obter mais informações, acesse: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Listen for Xdebug",
      "type": "php",
      "request": "launch",
      "hostname": "0.0.0.0",
      "port": 9003,
      "log": true,
      "pathMappings": {
        "/var/www/html":"${workspaceFolder}/app"
      },
      "ignore": ["**/vendor/**/*.php"],
      "xdebugSettings": {
        "max_children": 10000,
        "max_data": 10000,
        "show_hidden": 1
      }
    }
  ]
}
```


E por último edite o docker-compose.yml o serviço do php-fpm adicione o 'extra_hosts' para mapear o endereço host.docker.internal para o endereço IP da sua máquina.

Referências para configuração do Xdebug:
- https://dev.to/getjv/xdebug-3-docker-laravel-vscode-52bi
- https://blog.levacic.net/2020/12/19/xdebug-3-docker-vs-code-setup-guide-on-ubuntu/
