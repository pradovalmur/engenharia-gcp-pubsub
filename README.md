# Deploy infra as a code com terraform e Ingestão de dados no bigQuery atraves de cloud Functions, Pub/Sub

![alt text](https://github.com/pradovalmur/engenhariadotz2/blob/master/projeto%20engenharia%20dotz.png)

## Etapa 1

Criar o projeto no GCP com o nome testeengenharia, inclusive editando o ID, para que seja o mesmo do nome e em seguida criar uma conta de serviço com nome terraform, associando o papel de proprietario do projeto, criar as chaves e fazer download no formato json salvando o arquivo na pasta terraform.

Criar uma segunda conta de servico com nome function, e verificar se esta com o mesmo email na linha 45 do arquivo main.tf (terraform)

## Etapa 2

Editar o arquivo variables.tf, com o id do projeto criado no GCP e a região escolhida ( verificação). 

### Importante

Caso o nome do projeto não seja conforme orientado acima, sera necessario editar o arquivo main.py, localizado no arquivo zip na pasta artefacts

## Etapa 3

O próximo passo é autenticar-se com sua conta do google através do SDK. Execute gcloud init. O seu navegador deverá abrir automaticamente lhe pedindo a autenticação de sua conta do Google após você confirmar com um Y a solicitação no console ou terminal.

Após a Autenticação, acessar a pasta terraform e executar o comando terraform init, afim de preparar o terraform para execução no GCP.

Em seguida executar o comando terraform plan, para verificar todos os objetos a serem criado no GCP. Após verificação, executar o comando terraform apply para a criação dos objetos na infraestrutura do CGP. 

## Etapa 4

Na pasta Ingestion clonada no git hub, edite o arquivo ingestion-quoteprice.py, com o path do gatilho da cloud function e em seguida execute o script, repita esta alçai para os scripts ingestion-compboss.py e ingestion-billmaterials.py
 
Com esta ação os dados seram inseridos nas respecitivas tabelas do bigQuery, e aguardaram a execução do processo SQL agendado a cada 10 minutos (criados pelo Terraform)

Após a confirmação que as consultas agendadas e atualização do dataset DW_tubes estão sendo executadas, os relatórios poderam ser criados nas ferramentas de Dataviz / BI (PowerBI, Datastudio, etc)

Ao final do processo, apenas executar no terminal ou no promp o comando terraform destroy e toda a estrutura é apagada. 




