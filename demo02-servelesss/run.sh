#instalar
npm i -g serverless

#sls init
sls

#sempre fazer o deploy do ambiente 
sls deploy

#invocar AWS 
sls invoke -f hello

#invocar local 
sls invoke local -f hello -l

#configurar dashboard
sls 

#logs
sls logs -f hello --tail
