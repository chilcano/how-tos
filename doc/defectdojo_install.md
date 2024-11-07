# DefectDojo - Application Security Posture Management (ASPM) & Vulnerability Management

* https://github.com/DefectDojo/django-DefectDojo

## Install

These commands only will install DefectDojo using available docker images in DockerHub.

```sh
$ git clone https://github.com/DefectDojo/django-defectdojo
$ cd django-defectdojo

# start 
$ DD_TLS_PORT=7443 DD_PORT=7080 ./dc-up.sh

# start with detached mode
$ DD_TLS_PORT=7443 DD_PORT=7080 ./dc-up-d.sh
```

### Get password

#### Check if admin password has been created

```sh
$ docker compose logs initializer | grep -E "Admin" 

initializer-1  | Admin user: admin
initializer-1  | Admin password: Initialization detected that the admin user admin already exists in your database.

$ docker logs -f django-defectdojo-initializer-1

wait-for-it.sh: waiting max 60 seconds for postgres:5432
wait-for-it.sh: postgres:5432 is available after 0 seconds
============================================================
     Overriding DefectDojo's local_settings.py with multiple
     Files: /app/docker/extra_settings/README.md
============================================================
Initializing.
[07/Nov/2024 09:18:21] INFO [dojo.models:4589] enabling audit logging
Waiting for database to be reachable 
Checking ENABLE_AUDITLOG
[07/Nov/2024 09:18:22] INFO [dojo.models:4589] enabling audit logging
Database has been already migrated. Nothing to check.
Making migrations
[07/Nov/2024 09:18:23] INFO [dojo.models:4589] enabling audit logging
No changes detected in app 'dojo'
Migrating
[07/Nov/2024 09:18:25] INFO [dojo.models:4589] enabling audit logging
Operations to perform:
  Apply all migrations: admin, auditlog, auth, authtoken, contenttypes, django_celery_results, dojo, sessions, sites, social_django, tagging, watson
Running migrations:
  No migrations to apply.
Admin user: admin
[07/Nov/2024 09:18:27] INFO [dojo.models:4589] enabling audit logging
Admin password: Initialization detected that the admin user admin already exists in your database.
If you don't remember the admin password, you can create a new superuser with:
$ docker compose exec uwsgi /bin/bash -c 'python manage.py createsuperuser'
Creating Announcement Banner
[07/Nov/2024 09:18:28] INFO [dojo.models:4589] enabling audit logging
Initialization of test_types
[07/Nov/2024 09:18:28] INFO [dojo.models:4589] enabling audit logging
Creation of non-standard permissions
[07/Nov/2024 09:18:30] INFO [dojo.models:4589] enabling audit logging
[07/Nov/2024 09:18:31] INFO [dojo.management.commands.initialize_permissions:28] Non-standard permissions have been created
```

### Create a super user

```sh
$ docker compose exec uwsgi /bin/bash -c 'python manage.py createsuperuser'

[07/Nov/2024 09:10:51] INFO [dojo.models:4589] enabling audit logging
Username (leave blank to use 'defectdojo'): 
Email address: defectdojo@intix.info
Password: 
Password (again): 
Password must be at least 9 characters long.
Password must contain at least 1 digit, 0-9.
Password must contain at least 1 uppercase letter, A-Z.
The password must contain at least 1 special character, ()[]{}|`~!@#$%^&*_-+=;:'",<>./?.
Bypass password validation and create user anyway? [y/N]: y
[07/Nov/2024 09:11:44] INFO [dojo.utils:1815] creating default set of notifications for: defectdojo
Superuser created successfully.
```

## Check installation

TBC

## Browse DefectDojo

* Be aware we changed the HTTP and HTTPS ports. The new ones are `7080` and `7443`.
* Open [http://tawa.local:7080](http://tawa.local:7080)

## Using DefectDojo

* I'm going to use it to have a fully view of all vulnerabilities found in WeaveWorks SockShop. It is a demostration of how to build a Microservice Application.
* I've forked the demo repo: https://github.com/chilcano/microservices-demo/
* All microservices used in this applications have independent repositories and have different docker containers:
  - Repos:
    1. https://github.com/microservices-demo/front-end/
    2. https://github.com/microservices-demo/edge-router/
    3. https://github.com/microservices-demo/catalogue/
    4. https://github.com/microservices-demo/carts/
    5. https://github.com/microservices-demo/orders/
    6. https://github.com/microservices-demo/shipping/
    7. https://github.com/microservices-demo/queue-master/
    8. https://github.com/microservices-demo/payment/
    9. https://github.com/microservices-demo/user/
  - Docker Images:
    1. front-end
      * weaveworksdemos/front-end:0.3.12
    2. edge-router
      * weaveworksdemos/edge-router:0.1.1
    3. catalogue
      * weaveworksdemos/catalogue:0.3.5
    4. catalogue-db
      * weaveworksdemos/catalogue-db:0.3.0
    5. carts
      * weaveworksdemos/carts:0.4.8 
    6. carts-db
      * mongo:3.4
    7. orders
      * weaveworksdemos/orders:0.4.7
    8. orders-db
      * mongo:3.4
    9. shipping
      * weaveworksdemos/shipping:0.4.8
    10. queue-master
      * weaveworksdemos/queue-master:0.3.1
    11. rabbitmq
      * rabbitmq:3.6.8
    12. payment
      * weaveworksdemos/payment:0.4.3
    13. user
      * weaveworksdemos/user:0.4.4
    14. user-db
      * weaveworksdemos/user-db:0.4.0
    15. user-sim
      * weaveworksdemos/load-test:0.1.1

### 1. Generate Trivy reports for all of them

```sh
# scan remote repo and get JSON report
$ trivy repo -f json --pkg-types os,library --scanners vuln,secret,misconfig --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL https://github.com/microservices-demo/front-end -o trivy_out/report-front-end.repo.json

# scan remote docker image and get JSON report
$ trivy image -f json --pkg-types os,library --scanners vuln,secret,misconfig --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL weaveworksdemos/front-end:0.3.12 -o trivy_out/report-front-end.0.3.12.image.json
```

### 2. Import all reports into DefectDojo

* Follow this blog post: https://pvs-studio.com/en/docs/manual/6686/
* In brief, the manual process is:
  1. Create a Product: 
    - [http://tawa.local:7080/product/add](http://tawa.local:7080/product/add)
  2. Create an Engagement: 
    - Go to the created Product, there click on Engagements > Add New Interactive Engagement.
  3. Import Trivy reports:
    - Go to the created Engagement, there click on Findings > Import Scan Results.
    - Once imported, click in the 3-dots icon and select Edit option. Update the title, service, tags, version of the imported findings.

![](img/defectdojo-trivy-1.png)

