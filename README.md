````markdown
# Simple Drive

A unified interface for multiple storage backends.

## Table of Contents

- [Requirements](#requirements)
- [Installation & Configurations](#installation)
- [Usage](#usage)

## Requirements

To run this project, you need the following tools installed:

- Ruby 2.7.7

Optional for testing:

- [Postman](https://www.postman.com/downloads/)

## Installation

1. Install gems:

   ```sh
   bundle install
   ```

2. Storage Configuration:

   Inside `config/initializers/simple_drive.rb`, there are three different types of storage services: database, local storage, and cloud (Amazon S3 compatible).

   - **Database Setup:**
     To configure the service to store objects in the system database, ensure that the `STORAGE_SERVICE` constant is assigned to the database storage service:

     ```
     STORAGE_SERVICE = STORAGE_OPTIONS[:database]
     ```

   - **Local Storage:**
     To configure the service to store objects in local storage, replace the value with `local_storage`:

     ```
     STORAGE_SERVICE = STORAGE_OPTIONS[:local_storage]
     ```

     Also, make sure to specify the folder path:

     ```
     LOCAL_STORAGE_PATH = "YOUR_PATH"
     ```

   - **Cloud:**
     To store objects in Amazon S3 compatible storage (in this case, Alibaba Cloud OSS), replace the value with `cloud`:
     ```
     STORAGE_SERVICE = STORAGE_OPTIONS[:cloud]
     ```
     Open Rails credentials and add the following information:
     ```sh
     EDITOR=nano rails credentials:edit --environment development
     ```
     Replace the values with your corresponding service information:
     ```yaml
     alibaba_cloud_oss:
       endpoint: BUCKET_ENDPOINT
       access_key_id: ACCESS_KEY_ID
       access_key_secret: ACCESS_KEY_SECRET
       bucket_name: BUCKET_NAME
     ```

3. Run the app:
   ```sh
   rails server
   ```

## Usage

### Endpoints

- **Authentication:**

  1. `POST /v1/auth/register`

     - Description: Register a new user
     - Request Parameters: email*, password*
     - Response Parameters: success message
     - Request Body:
       ```json
       {
         "email": "m2@m.com",
         "password": "123"
       }
       ```
     - Example Response:
       ```json
       {
         "code": 200,
         "message": "User registered successfully"
       }
       ```

  2. `POST /v1/auth/login`
     - Description: Login an existing user
     - Request Parameters: email*, password*
     - Response Parameters: success message, token
     - Request Body:
       ```json
       {
         "email": "m2@m.com",
         "password": "123"
       }
       ```
     - Example Response:
       ```json
       {
         "code": 200,
         "message": "Logged in successfully",
         "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozLCJyYW5kb21fc3RyaW5nIjoiYWJmMTk2MDg3ZWVmM2U0ZDlkYTcifQ.XXhJyQorinUv6xCD5ykv-cwOIatzHehhn9-irJvBHjg"
       }
       ```

- **Blobs:**

  1. `POST /v1/blobs`

     - Description: Upload objects/blobs to storage service
     - Request Headers: authorization token\*
     - Request Body: id*, data*
     - Response Parameters: success message
     - Request Body:
       ```json
       {
         "id": "my_data",
         "data": "SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh"
       }
       ```
     - Example Response:
       ```json
       {
         "code": 200,
         "message": "Data uploaded successfully"
       }
       ```

  2. `GET /v1/blobs/<id>`
     - Description: Retrieve objects/blobs from storage service
     - Request Headers: authorization token\*
     - Request Params: id\*
     - Response Parameters: object data
     - Example Response:
       ```json
       {
         "id": "my_data",
         "data": "SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh",
         "size": 27,
         "created_at": "2024-03-19T08:18:10Z"
       }
       ```
````
