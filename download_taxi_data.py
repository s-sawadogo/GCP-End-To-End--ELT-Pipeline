import requests
import time
from datetime import datetime
from google.cloud import storage
import logging  #logging.info so important to know
import io
from datetime import UTC  # Import UTC explicitly

# Project ID and Bucket name
PROJECT_ID = "possible-coast-463614-i9"  #Avec la commande "gcloud projects list" dans le terminal
BUCKET_NAME = f"{PROJECT_ID}-data-bucket"
GCS_FOLDER = "dataset/trips/"
GCS_LOG_FOLDER = "from-git/logs/"

# Initialize Google Cloud Storage client
storage_client = storage.Client()

# Set up logging
log_stream = io.StringIO()
logging.basicConfig(stream=log_stream, level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


def file_exists_in_gcs(bucket_name, gcs_path):
    """Check if a file already exists in GCS."""
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(gcs_path)
    return blob.exists()

def upload_log_to_gcs():
    """Upload the log file to GCS."""
    #log_filename = f"{GCS_LOG_FOLDER}extract_log_{datetime.utcnow().strftime('%Y%m%d_%H%M%S')}.log"
    log_filename = f"{GCS_LOG_FOLDER}extract_log_{datetime.now(UTC).strftime('%Y%m%d_%H%M%S')}.log"
    bucket = storage_client.bucket(BUCKET_NAME)
    blob = bucket.blob(log_filename)
    blob.upload_from_string(log_stream.getvalue())
    logging.info(f"Log file uploaded to {log_filename}")

def download_histo_data():
    """
    Downloads the PARQUET files of yellow taxis from 2022 to the current year and sends them directly to Google Cloud Storage under trips/ folder.
    """
    current_year = datetime.now().year

    try:
        for year in range(2022, current_year + 1):
            for month in range(1, 13):
                file_name = f"yellow_tripdata_{year}-{month:02d}.parquet"
                gcs_path = f"{GCS_FOLDER}{file_name}"
                download_url = f"https://d37ci6vzurychx.cloudfront.net/trip-data/{file_name}"

                if file_exists_in_gcs(BUCKET_NAME, gcs_path):
                    logging.info(f"{file_name} already exists in GCS, skipping...")
                    continue

                try:
                    logging.info(f"Downloading {file_name}...")
                    response = requests.get(download_url, stream=True)

                    if response.status_code == 200:
                        #upload_to_gcs(BUCKET_NAME, gcs_path, response.content)
                        bucket = storage_client.bucket(BUCKET_NAME)
                        blob = bucket.blob(gcs_path)
                        blob.upload_from_string(response.content)
                        logging.info(f"Uploaded {file_name} to GCS at {gcs_path}")

                    elif response.status_code == 404:
                        logging.warning(f"File {file_name} not found on source, skipping...")
                    else:
                        logging.error(f"Failed to download {file_name}. HTTP status code: {response.status_code}")
                except Exception as e:
                    logging.error(f"Error downloading {file_name}: {str(e)}")

                time.sleep(1)
        logging.info("Download and upload to GCS completed!")
    except Exception as e:
        logging.error(f"Unexpected error: {str(e)}")
    finally:
        upload_log_to_gcs()


if __name__ == '__main__':
    logging.info(f"Date of historical data download: {datetime.today()}")
    download_histo_data()
