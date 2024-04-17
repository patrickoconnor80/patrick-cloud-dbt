FROM python:3.9

# Install DBT Python Package
RUN pip install dbt-core==1.7.11
RUN pip install dbt-databricks==1.7.13

# Copy all contents of repo into container
RUN mkdir dbt
COPY . dbt
WORKDIR dbt

# Prep for container execution
ENTRYPOINT ["/bin/bash", "bin/entrypoint.sh"]