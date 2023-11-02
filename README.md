# iacOblig2

## Task: Terraform Mandatory Assignment: CI/CD and testing
 
The goal of this assignment is to create a good CI/CD workflow with for our Terraform IaC with Github Actions.
 
### Initial setup
Use a small and simple known infrastructure (could be module 7 demo-infra from already known git repo: https://github.com/torivarm/iac-terraform.git). Set up secrets in your GitHub repository for Azure credentials and any other sensitive informasjon. Configure the Terraform AzureRM backend to store the state files in Azure Storage Account. Make sure the backend configuration supports workspaces by making the storage key dynamic based on the workspace name.

### Use-Case senario
OperaTerra AS has caught traction in the IT market and famous for its skilled junior consultants. To keep up with the market and its demands, they now have to implement a good CI/CD workflow for its customers that already have a good scalable, secure, and easily maintainable Terraform code base. Customers wants a presentation of different approaches for how to implement a good practice for CI/CD with both workspaces and use of branches.
 
### The to-do:
- Customer requirements – Use of workspaces and Git branches
- Three workspaces with the following names: dev, stage and prod
- Terraform code base must include workspace-specific configurations (such as names, tags, etc.)
- For infrastructure configuration it should be created branches (remember good naming convention and life cycle) that should undergo code reviews (terraform fmt, terraform validate and tflint) before they are merged into the environment branches (e.g., dev, staging, prod), which providing a layer of quality assurance.
- Create Pull Request to perform merging with environment branches.
- Merging with environment branches should trigger a workflow that will plan and apply infrastructure to workspaces except prod
- For deoployment of infrastructure in prod it must be aproved by a minimum of one person.
 
 
### Deliverables
IMPORTANT! A .zip-file with the following name, files and folders: Name the zip file with the ntnu username and oppg2, such as: melling-oppg2.zip In the zip file there must be a folder with the same name as the zip file: ntnuusername-oppg1, such as: melling-oppg2. The folder naturally contains the terraform files and folders. The reason for the naming is to streamline censorship and display in VS Code.

- A README.md file explaining:
    - How to use the Terraform scripts
    - Any pre-requisites or dependencies
- A terraform.tfvars file containing values for all the input variables.
- Output screenshots showing the successful workflow and the deployed infrastructure. Remember to destroy resources when you are done.

**Evaluation Criteria:** Code quality, functionality, documentation, reusability. <br>
**Deadline:** 05. November 2023 - 23:59


## Use Guide


### Branches


This repository strucutre mainly uses two branches, *dev* and *main*. The intention is that work on specific tasks is conducted within enviorment branches, wich are then merged into the dev branch via pull request. Code quality checks are performed upon creating a pull request with the dev branch. After the checks have passed and the branches have merged, *dev* will automaticly clean up any ugly code, and the new version is deployed to azure under the *dev* suffix. 

Once a new version is ready for release, a pull request is created towards the *main* branch from the *dev* branch. First, a new version of the infrastructure is tested under the *stage* suffix. Tests are then conducted on the live code in this enviorment. If all checks pass, and at least one person have personally approved of the merge, then the dev branch may be merged with the main branch. The main branch automaticly deploys, and the new version is live.
```
Env branch              Dev branch                      Main branch
    :                      /|                               |
    :_______new branch____/ |                               |
    |                       |                               |
    |                       |                               |
    |\ Pull request         |                               |
    | \                     |                               |
    |  x testing failed     |                               |
    | <-fix code            |                               |
    |\                      |                               |
    | \                     |                               |   
    |  v testing success    |                               |
    |   \_________merge_____|                               |
    x branch killed         | <-Deploy dev                  |
                            |                               |
                            |\ Pull request                 |
                            | \ Deploy staging enviorment   |
                            |  \ Test staging enviorment    |
                            |   x Test failed               |
                            |                               |
                            | <-fix code                    |
                            |                               |
                            |\ Pull request                 |
                            | \ Deploy staging enviorment   |
                            |  \ Test staging enviorment    |
                            |   v Test success              |
                            |    \                          |
                            |     \ Manually approved       |
                            |      \_________merge__________|
                            |                               | <- Deploy prod
```



### Screenshots