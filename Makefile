.PHONEY: validate create update

include default.properties

validate:
	aws cloudformation validate-template --template-body file://$(pipeline.template)

create:
	aws cloudformation create-stack \
		--stack-name $(pipeline.stack-name) \
		--template-body file://$(pipeline.template) \
		--parameters \
			ParameterKey=Owner,ParameterValue=$(params.owner) \
			ParameterKey=Repo,ParameterValue=$(params.repo) \
			ParameterKey=Branch,ParameterValue=$(params.branch) \
			ParameterKey=ProjectOAuthTokenSecretName,ParameterValue=$(params.project-oauth-token-param-name) \
			ParameterKey=WebHookOAuthTokenSecretName,ParameterValue=$(params.webhook-oauth-token-param-name) \
			ParameterKey=PipelineName,ParameterValue=$(pipeline.name) \
			ParameterKey=SSMParamName,ParameterValue=$(ssm-param-name)
	aws cloudformation wait stack-create-complete --stack-name $(pipeline.stack-name)

