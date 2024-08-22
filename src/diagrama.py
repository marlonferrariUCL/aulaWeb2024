from diagrams import Cluster, Diagram
from diagrams.aws.compute import Lambda
from diagrams.aws.database import ElastiCache, RDS
from diagrams.aws.network import ELB, Route53, APIGateway
from diagrams.aws.management  import Cloudwatch

<<<<<<< HEAD
with Diagram("Meu Diagrama 001", show=False):
    dns = Route53("dns")
    lb = ELB("lb")
    api_gateway = APIGateway("API Gateway")
=======
>>>>>>> 9b76d3e (Remove lines)


    with Cluster("DB Cluster"):
        db_primary = RDS("userdb")
        db_primary - [RDS("userdb ro")]

    memcached = ElastiCache("memcached")
    logs = Cloudwatch("logs")

    dns >> lb >> api_gateway >> lambda_group
    lambda_group >> db_primary
    lambda_group >> memcached
    lambda_group >> logs
    api_gateway >> logs