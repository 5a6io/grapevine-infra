# grapevine-infra

인프라 자동화를 위한 코드입니다.
AWS 기반의 ECS Fargate, CloudFront, Route53, S3, IAM, Monitoring 등을 모듈화하여 관리하며, 환경별 분리와 배포 자동화를 고려한 구조입니다.

### 🚀 Quick Start

환경별 `.tfvars` 파일을 지정하여 Terraform 실행:

```yaml
cd stacks

# 초기화
terraform init

# 계획 확인
terraform plan -var-file="../environments/dev/terraform.tfvars"

# 적용
terraform apply -var-file="../environments/dev/terraform.tfvars"
```

또는 `.auto.tfvars` 형식을 사용할 경우 자동 로딩됩니다.

### **📁 Directory Structure**

```
.
├── environments/               # dev/staging/prod 환경 변수 정의
│   ├── dev/terraform.tfvars
│   ├── prod/terraform.tfvars
│   └── staging/terraform.tfvars

├── modules/                    # 재사용 가능한 인프라 구성 모듈
│   ├── compute/
│   │   ├── ecr/
│   │   ├── ecs-cluster/
│   │   ├── ecs-services/
│   │   └── ecs-task-definition/
│   ├── edge/
│   │   ├── acm/
│   │   ├── cloudfront/
│   │   ├── route53/
│   │   └── vpc-endpoints/
│   ├── monitoring/
│   ├── network/
│   │   ├── igw-nat/
│   │   ├── loadbalancer/
│   │   ├── subnets/
│   │   └── vpc/
│   ├── s3/
│   └── security/
│       ├── iam/
│       └── security-group/

├── stacks/                    # 스택 조합 및 배포 실행 파일
│   ├── 00-providers.tf
│   ├── 01-vpc.tf
│   ├── 02-subnets.tf
│   ├── 03-security.tf
│   ├── 04-loadbalancer.tf
│   ├── 05-ecr.tf
│   ├── 06-ecs-cluster.tf
│   ├── 07-ecs-services.tf
│   ├── 08-cloudfront.tf
│   ├── 09-route53.tf
│   ├── outputs.tf
│   └── variables.tf

├── variables.tf               # 공통 변수 정의
└── providers.tf               # 공통 provider 정의
```

### **📦 Modules**

| **Name** | **Description** |
| --- | --- |
| network/vpc | 기본 VPC 구성 |
| network/subnets | 퍼블릭/프라이빗 서브넷 구성 |
| network/loadbalancer | ALB 설정 및 리스너 구성 |
| compute/ecr | 컨테이너 이미지 저장소 |
| compute/ecs-cluster | ECS 클러스터 생성 |
| compute/ecs-task-definition | Task 정의 (컨테이너 이미지 포함) |
| compute/ecs-services | ECS 서비스 배포 및 ALB 연동 |
| security/iam | IAM 역할 및 정책 관리 |
| security/security-group | 보안 그룹 관리 |
| edge/route53 | 도메인 설정 |
| edge/cloudfront | 정적 파일 배포용 CDN 구성 |
| edge/acm | TLS 인증서 관리 |
| monitoring | CloudWatch 지표 및 로그 설정 |

### **☁️ Environments**

`environments/{dev, staging, prod}/terraform.tfvars` 파일을 통해 환경별 변수 분리 관리가 가능합니다.

| **Name** | **Description** |
| --- | --- |
|  |  |
|  |  |

예시:

```
environment = "dev"
region      = "ap-northeast-2"
domain_name = "dev.example.com"
```

### **🧩 Naming Convention**

- Terraform 모듈 내부 변수: lowerCamelCase
- 공통 태그, 리소스 이름: Project, Environment, Name 태그 사용
- ALB, ECS 서비스 등에는 ${var.environment}-${name} 형태 적용

### **✅ Requirements**

| **Name** | **Version** |
| --- | --- |
| Terraform | ≥ 1.3 |
| AWS Provider | ≥ 4.0 |

### **🗂️ Backend (예시)**

```
terraform {
  backend "s3" {
    bucket         = "my-tfstate-bucket"
    key            = "terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

### **👏 Contributors**

- 구조 설계 및 모듈화: [Your Name or Team]
- 기준 아키텍처: ECS Fargate 기반 서비스 배포 자동화 구조
