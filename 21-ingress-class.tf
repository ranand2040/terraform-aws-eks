# Resource: Kubernetes Ingress Class
resource "kubernetes_ingress_class_v1" "ingress_class_default" {
  depends_on = [aws_acm_certificate_validation.example-app-wild-card-dev]
  metadata {
    name = "nginx"
    annotations = {
      "ingressclass.kubernetes.io/is-default-class" = "true"
      "kubernetes.io/ingress.class"                 = "alb"
      "alb.ingress.kubernetes.io/target-type"       = "ip"
      "alb.ingress.kubernetes.io/scheme"            = "internet-facing"
      "alb.ingress.kubernetes.io/listen-ports"      = "[{'HTTPS':443}, {'HTTP':80}]"
      "alb.ingress.kubernetes.io/ssl-redirect"      = "443"
      "alb.ingress.kubernetes.io/success-codes"     =  "200-399"
      "alb.ingress.kubernetes.io/load-balancer-attributes" = "idle_timeout.timeout_seconds=600"
      "alb.ingress.kubernetes.io/certificate-arn"   = aws_acm_certificate.example-app-wild-card-dev.arn
    }
  }  
  spec {
    controller = "ingress.k8s.aws/alb"
  }
}

## Additional Note
# 1. You can mark a particular IngressClass as the default for your cluster. 
# 2. Setting the ingressclass.kubernetes.io/is-default-class annotation to true on an IngressClass resource will ensure that new Ingresses without an ingressClassName field specified will be assigned this default IngressClass.  
# 3. Reference: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/guide/ingress/ingress_class/

