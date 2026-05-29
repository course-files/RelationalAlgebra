# Relational Algebra

| Key             | Value                                                                                                                                                                                                                                                                           |
|:----------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Course Code** | MCS 8104 and DAT 2201                                                                                                                                                                                                                                                                        |
| **Course Names** | MCS 8104: Database Management Systems<br>BBT 1202: Database Systems<br>DAT 2201: Database Design and SQL                                                                                                                                                                                                                                    |
| **Semester**    | May to August 2026                                                                                                                                                                                                                                                              |
| **Lecturer**    | Allan Omondi                                                                                                                                                                                                                                                                    |
| **Contact**     | aomondi@strathmore.edu                                                                                                                                                                                                                                                          |
| **Note**        | The lecture contains both theory and practice.<br/>This notebook forms part of the practice.<br/>It is intended for educational purposes only.<br/>Recommended citation: [BibTex](https://raw.githubusercontent.com/course-files/RelationalAlgebra/refs/heads/main/RecommendedCitation.bib) |

## Technology Stack

<p align="left">
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/vscode/vscode-original-wordmark.svg" width="40"/>
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/linux/linux-original.svg" width="40" />
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/ubuntu/ubuntu-original-wordmark.svg" width="40" />
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/postgresql/postgresql-original-wordmark.svg" width="40"/> 
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/datagrip/datagrip-original.svg" width="40"/>
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/git/git-original-wordmark.svg" width="40"/>
</p>

## System Architecture

![System Architecture](assets/images/SystemArchitecture.jpg)

## Entity-Relationship Diagram (ERD)

![ERD of Siwaka Dishes](assets/images/ERD_of_siwaka_dishes_From_DBeaver.png)

## Repository Structure

```text
.
├── 1_Install_PostgreSQL_in_Ubuntu_Server.md
├── 2_Relational_Algebra.md
├── LICENSE
├── README.md
├── RecommendedCitation.bib
├── assets
│   ├── ERD_of_siwaka_dishes.pgerd
│   ├── ERD_of_siwaka_dishes_From_DataGrip.drawio
│   └── images
│       ├── ERD_of_siwaka_dishes_From_DBeaver.png
│       ├── ERD_of_siwaka_dishes_From_DataGrip.png
│       ├── ERD_of_siwaka_dishes_From_PGAdmin.png
│       ├── SystemArchitecture.jpg
│       ├── TieredArchitecture.png
│       ├── images_and_containers.jpg
│       └── virtualization_and_containerization.png
└── data
    └── 202605
        ├── 0_a_DDL_siwaka_dishes_original.sql
        ├── 1_a_DML_general_data.sql
        ├── 1_c_DML_employee_data.sql
        ├── 2_b_DML_customer_data.sql
        ├── 3_b_DML_customer_order_data.sql
        ├── 4_b_DML_order_detail_data.sql
        ├── 5_b_DML_payment_data.sql
        ├── 6_b_DML_customer_feedback_data.sql
        └── 7_a_DDL_other_DB_objects.sql

5 directories, 23 files
```

## Setup Instructions

- [Install PostgreSQL locally, in Ubuntu Server, and through a Docker container](1_Install_PostgreSQL_in_Ubuntu_Server.md)

## Lab Manual

Refer to the file below for more details:

- [Relational Algebra](2_Relational_Algebra.md)

## Lab Submission Instructions

Refer to the end of the file below for more details:

- [Relational Algebra](2_Relational_Algebra.md)

## Cleanup Instructions (to be done after submitting the lab)

- You can delete the entire Virtual Machine instance that you created for this lab to free up resources on your laptop.

- However, if you wish to keep the instance for future use, you can simply stop it instead of deleting it. Stopping the instance will free up resources while allowing you to start it again whenever needed without having to go through the setup process again.

- For the sake of the semester-long project, you can stop it when you are not using it to save resources, and start it again when you need to work on the project.

- You can also delete the PostgreSQL container if you used Docker for the lab, but if you wish to keep it for future use, you can simply stop the container instead of deleting it. Stopping the container will free up resources while allowing you to start it again whenever needed without having to go through the setup process again.
