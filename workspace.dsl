workspace "Banca por Internet" "Arquitectura del sistema de banca en línea" {

    model {
        // **Definición de Actores**
        cliente = person "Cliente" {
            description "Usuario que accede al sistema de Banca por Internet para realizar operaciones financieras."
        } 

        // **Definición de Sistemas Externos**
        plataformaCore = softwareSystem "Plataforma CORE" "Core bancario que almacena información de clientes, productos y movimientos." {
            tags "Sistema Externo"
        }
    
        sistemaIndependiente = softwareSystem "Sistema Independiente" "Sistema complementario que proporciona detalles adicionales de los clientes." {
            tags "Sistema Externo"
        }

        sistemaNotificacion = softwareSystem "Sistema de notificación" "Sistema de notificación." {
            tags "Sistema Externo"
        }

        // **Sistema de Banca por Internet**
        bancaInternet = softwareSystem "Sistema de Banca por Internet" "Plataforma digital que permite a los clientes consultar movimientos, realizar transferencias y pagos." {

            // **Frontend**
            spa = container "SPA" "Aplicación Web (VueJS)" "Aplicación Web desarrollada con VueJS para acceso desde navegadores." {
                technology "VueJS + TypeScript"
            }
      
            appMovil = container "App Móvil" "Aplicación Móvil (Flutter)" "Aplicación Móvil multiplataforma desarrollada con Flutter." {
                technology "Flutter + Dart"
            }

            // **Backend - API Gateway**
            apiGateway = container "API Gateway" "Punto de entrada a los servicios backend, gestionado con AWS API Gateway." {
                technology "AWS API Gateway"
                tags "Amazon Web Services - API Gateway"

                // **Servicio de Autenticación**
                authService = component "Onboarding" "Gestiona autenticación de nuevos usuarios mediante OAuth2.0 y reconocimiento facial." {
                    technology "AWS Cognito"
                    tags "Amazon Web Services - Cognito"
                }

                // **Servicio de Transferencias**
                transferenciasService = component "Servicio de Transferencias" "Procesa pagos, transferencias entre cuentas propias e interbancarias." {
                    technology "AWS Lambda + Java Spring Boot"
                    tags "Amazon Web Services - Lambda"
                }

                // **Servicio de Movimientos**
                movimientosService = component "Servicio de Movimientos" "Consulta el histórico de movimientos de los clientes." {
                    technology "AWS Lambda + DynamoDB"
                    tags "Amazon Web Services - DynamoDB"
                }

                clienteCache = component "Persistencia de Clientes Frecuentes" "Optimiza el acceso a datos frecuentes de clientes." {
                    technology "Amazon DynamoDB"
                    tags "Amazon Web Services - DynamoDB"
                }

                // **Servicios AWS para notificaciones**
                awsSNS = component "AWS SNS" "Servicio de notificaciones para el envío de SMS." {
                    technology "AWS Simple Notification Service"
                    tags "Amazon Web Services - Simple Notification Service"
                }
      
                awsSES = component "AWS SES" "Servicio de correo electrónico transaccional." {
                    technology "AWS Simple Email Service"
                    tags "Amazon Web Services - Simple Email Service Email"
                }


                // **Servicio de Auditoría**
                auditoriaService = component "Servicio de Auditoría" "Registra todas las acciones de los clientes en un sistema de auditoría." {
                    technology "Amazon OpenSearch (Elasticsearch) + Kibana"
                    tags "Amazon Web Services - Elastic Beanstalk"
                }

                // **Bases de Datos**
                auditDB = component "Base de Datos de Auditoría" "Almacena logs y auditoría de transacciones." {
                    technology "Amazon RDS (PostgreSQL)"
                    tags "Amazon Web Services - Aurora PostgreSQL Instance"
                }

            }

           
      
            
        }

        // **Definición de Relaciones**
        cliente -> bancaInternet "Accede a los servicios bancarios"
        cliente -> spa "Accede a través del navegador"
        cliente -> appMovil "Accede desde su teléfono"

        spa -> apiGateway "Envía solicitudes"
        appMovil -> apiGateway "Envía solicitudes"

        apiGateway -> sistemaNotificacion "Notificar vía"
        apiGateway -> plataformaCore "Valida credenciales y consulta datos, registra movimientos"
        apiGateway -> sistemaIndependiente "Consulta datos con detalle"
        sistemaNotificacion -> cliente "Enviar a"

        appMovil -> authService "Autenticacion y Autorizacion con Huella"
        spa -> authService "Autenticación y Autorizacion con usuario y clave"

        appMovil -> clienteCache "Consulta datos y movimientos (HTTPS)."
        spa -> clienteCache "Consulta datos y movimientos (HTTPS)."
        authService -> plataformaCore "Valida datos"
        clienteCache -> plataformaCore "Obtiene datos"
        clienteCache -> sistemaIndependiente "Obtiene datos con detalle"

        appMovil -> transferenciasService "Realizar pagos y transferencias (HTTPS)"
        spa -> transferenciasService "Realizar pagos y transferencias (HTTPS)"

        appMovil -> movimientosService "Consultar movimientos (HTTPS)"
        spa -> movimientosService "Consultar movimientos (HTTPS)"

        appMovil -> auditoriaService "Auditar acciones"
        spa -> auditoriaService "Auditar acciones"

        auditoriaService -> auditDB "Almacenar logs de auditoria"

        transferenciasService -> plataformaCore "Procesar pagos y transferencias"
        movimientosService -> sistemaIndependiente "Consultar datos con detalle"

        movimientosService -> sistemaNotificacion "Notificar via sistema propio"
        movimientosService -> awsSES "Notificar via"
        movimientosService -> awsSNS "Notificar via"
        awsSES -> cliente "Notificacion por e-mail"
        awsSNS -> cliente "Notificar por SMS"



        

        
    }

    views {
        systemContext bancaInternet "DiagramaContexto_Sistema_Banca_Internet" {
            include *
            autolayout
        }

        container bancaInternet "DiagramaContenedor_bancaInternet" {
            include *
            
            autolayout
        }

        component apiGateway "DiagramaComponente_apiGateway" {
            include *
            autolayout
        }        

        styles {
            element "Sistema Externo" {
                background "#f4c542"
                color "#000000"
                border "Dashed"
            }
            element "ClienteFrecuente" {
                background "#578FCA"
            }
        }

        
        theme "https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json"
        theme default
    }
}
