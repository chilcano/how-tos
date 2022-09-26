# CodePipeline with CDK

## Steps

### Step 1. Prepare the CDK project

```sh
# initialize subdir as worktree to allocate cdk project
$ source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/git_worktree_initialize.sh) api-lambda-pipeline

$ sed -i -e '$aapi-lambda-pipeline' .gitignore

$ git add .; git commit -m "cdk app api-lambda-pipeline added"; git push

$ cd api-lambda-pipeline

$ cdk init --language="typescript"

$ mkdir lambda; cd lambda
$ git clone https://github.com/evayde/cdk-lambda-api-fastify.git .
$ rm -rf .git cdk


# modules required by lambda-stack.ts
$ npm i -S @aws-cdk/aws-lambda @aws-cdk/aws-apigateway @aws-cdk/aws-cloudfront @aws-cdk/aws-codedeploy

#### error in deploy
# src/lambda.ts(1,30): error TS7016: Could not find a declaration file for module 'aws-lambda-fastify'. '/codebuild/output/src949431620/src/lambda/node_modules/aws-lambda-fastify/index.js' implicitly has an 'any' type.
#
# Try `npm install @types/aws-lambda-fastify` if it exists or add a new declaration (.d.ts) file containing `declare module 'aws-lambda-fastify';`

$ npm i -S aws-lambda-fastify

# yarn add -D typescript @types/node
# yarn add fastify aws-lambda-fastify
# yarn add @aws-cdk/aws-lambda @aws-cdk/aws-apigatewayv2 @aws-cdk/aws-apigatewayv2-integrations @aws-cdk/aws-cloudfront

# modules required by pipeline-stack.ts
npm i -S @aws-cdk/aws-codebuild @aws-cdk/aws-codepipeline @aws-cdk/aws-codepipeline-actions
```

### Step 2. Deploy the PipelineStack

```sh
# working with different environments (windows, mac, ...)
npm i -D cross-env

# We do not have to use cdk synth , because we are doing it in bin/cdk-api-pipeline.ts on the last line.

##### deploying the stacks
npx cross-env GITHUB_TOKEN="abcxyz" cdk deploy PipelineStack

#### destroying the stacks

# The correct order is deleting the Lambda Stack first and then removing the Pipeline Stack (reverse order of creation). 
# If you did attempt removal in the wrong order, then you may have to create an IAM role manually to make it work again.

aws cloudformation delete-stack --stack-name LambdaDeploymentStack --region eu-west-1
npx cross-env GITHUB_TOKEN="abcxyz" cdk destroy LambdaStack
npx cross-env GITHUB_TOKEN="abcxyz" cdk destroy PipelineStack
```

## Todo

- Invalidation for your CloudFront. New changes in the GitHub repo, the lambda will update automatically, but you will not see new content. This is due to CloudFronts caching mechanism. You can either add some Behaviours to deactivate caching or add an Invalidation Lambda to trigger a CloudFront Invalidation.
- Find a better way to provide your GitHub API Key (like AWS Secret Manager).

## References

1. Original article: 
https://medium.com/swlh/github-codepipeline-with-aws-cdk-and-typescript-d37183463302
2. Here is the original code by AWS (not using GitHub): 
https://docs.aws.amazon.com/cdk/latest/guide/codepipeline_example.html
3. Here is my older article about deploying an API to AWS Lambda: 
https://medium.com/@enrico.gruner90/aws-cdk-and-typescript-deploy-an-api-server-to-aws-lambda-7a13f7bb27da
4. Here you can find another article on deploying a static CRA to S3: 
https://medium.com/swlh/aws-cdk-and-typescript-deploy-a-static-react-app-to-s3-df74193e9e3d

