# Set up Environment
1. Install Docker Engine/Docker Desktop: [Linux](https://docs.docker.com/engine/install/)| [Mac/Windows](https://docs.docker.com/get-started/introduction/get-docker-desktop/)
2. install Python 3.9 or higher
3. Create python env in ep1 folder
    ```
    python3 -m venv .venv
    ```
4. Activate python env(mac/linux)
    ```
    source .venv/bin/active
    ```
5. Activate python env(CMD Windows)
    ```
    .venv\Scripts\activate.bat
    ```


# Lab 1

1. Start Redis, Postgres, Mongo DB(in detach mode)
    ```
        docker compose up -d
    ```
2. Open `Lab1-bds` in Vs code or Jypyter
3. Select Python interpreter from VS Code/Jupyter(the one created above)
4. Run the notebook
5. Stop containers
    ```
    docker compose down
    ```


# Lab 2
1. Start Spark-master, work-node, jupyter(in detach mode)
    ```
    docker compose --file=compose-spark.yaml up -d
    ```
2. In the browser open localhost:8888 to open jupyterlab
3. Run the nootebook under work folder(all data is in data folder)
4. Stop the containers
    ```
    docker compose --file=compose-spark.yaml down
    ```


