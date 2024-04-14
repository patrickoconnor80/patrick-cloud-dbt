FROM python:3.9

# Install DBT Python Package
RUN pip install dbt-core==1.7.11

# Copy all contents of repo into container
RUN mkdir dbt
COPY . dbt

# Prep for container execution
ENTRYPOINT ["/bin/bash", "dbt/bin/entrypoint.sh"]