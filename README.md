# Deploy infra as a code com terraform e Ingestão de dados no bigQuery atraves de cloud Functions, Pub/Sub

## Etapa 1

Criar o projeto no GCP com o nome engenhariadedados-terraform2, inclusive editando o ID, para que seja o mesmo do nome e em seguida criar uma conta de serviço, associando o Papel de proprietario do projeto e editor do pub/sub (Mais detalhes no link: https://blog.marcelocavalcante.net/terraform-criando-uma-infraestrutura-no-google-cloud/ ).

Criar a chave de acesso (conforme orientado no link acima) e salvar o arquivo na pasta terraform2, no formato json.

## Etapa 2

Editar o arquivo variables.tf, com o id do projeto criado no GCP e a região escolhida. 

### Importante

Caso o nome do projeto não seja conforme orientado acima, sera necessario editar o arquivo main.py, localizado no arquivo zip na pasta artefacts

## Etapa 3

O próximo passo é autenticar-se com sua conta do google através do SDK. Execute gcloud init. O seu navegador deverá abrir automaticamente lhe pedindo a autenticação de sua conta do Google após você confirmar com um Y a solicitação no console ou terminal.

Após a Autenticação, acessar a pasta terraform2 e executar o comando terraform init, afim de preparar o terraform para execução no GCP.

Em seguida executar o comando terraform plan, para verificar todosa os objetos a serem criado no GCP. Após verificação, executar o comando terraform apply para a criação dos objetos na infraestrutura do CGP. 

## Etapa 4

Após o terraform criar todos os objetos no GCP, será necessario a criação do processo do dataflow, cara ingestão das mensagem de cada topico no pub/sub em uma tabela do bigQuery já criada pelo terraform.

  1. Acesse o topic quote_price;
  2. Crie assinatura do tipo exportar para bigQuery (será aberta uma nova aba do GCP com o dataflow);
  3. Configure o nome da tabela do bigQuery (tb_quoteprice);
  4. Configure o nome de uma pasta temp (gs://functionrecursos/temp);
  5. Clique em executar  Job;
  6. Na pasta Ingestion clonada no git hub, edite o arquivo ingestion-quoteprice.py, com o path do gatilho da cloud function e em seguida execute o script
      obs: Será iniciado o processo de envio dos registros do arquivo price_quote.csv salvo na pasta data para a tabela tb_quote_price, atraves do cloud function (metodo post), pub/sub e dataflow.
      obs2: Leva cerca de 5 minutos da criação do data flow para os dados comecarem a ser inseridos no bigquery. 
      
Repita os passos acima para todos outros dois topicos do pub/sub, alterando os nomes dos arquivos (não precisa alterar o path da cloud function, o codigo python já separa e envia cara o topico correto). 


Após estas etapas e a verificação que tudo esta funcionando, podemos fazer a utilização dos dados no bigQuery, com a modelagem e a criação de relatórios no datastudio ou outra plataforma de dataviz.

Ao final do processo, apenas executar no terminal ou no promp o comando terraform destroy e toda a estrutura é apagada ( será necessario interromper o dataflow nmanualmente). 




