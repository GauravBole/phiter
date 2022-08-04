import os
from shutil import make_archive
import shutil
import zipfile

import boto3

class PhiterPackages:

    def __init__(self) -> None:
        self.git_repo = "https://github.com/GauravBole/botobeak.git"

    def __change_temp_dir(self, temp_dir_path:str):
        current_dir = os.getcwd()
        temp_dir_absolute_path = os.path.join(current_dir, temp_dir_path)
        os.makedirs(temp_dir_absolute_path, exist_ok=True)
        os.chdir(temp_dir_absolute_path)
        return f"{current_dir}/{temp_dir_path}"
    
    def download_repo(self):
        self.__change_temp_dir("temp/")
        os.system(f"git clone {self.git_repo}")
    
    def zip_folder(self):
        # make_archive("botobeak", "zip", root_dir="./botobeak")
        zf = zipfile.ZipFile("botobeak.zip", "w")
        for dirname, _, files in os.walk("botobeak"):
            if ".git" in dirname:
                continue
            zf.write(dirname)
            for filename in files:
                zf.write(os.path.join(dirname, filename))
        zf.close()
        shutil.rmtree(os.path.join(os.getcwd(), "botobeak/"))


    def copy_zip_to_s3(self, bucket_name:str):
        zip_path = os.path.join(os.getcwd(), "botobeak.zip")
        s3 = boto3.resource('s3', aws_access_key_id="AKIAT4636MDWARSBDT6F", aws_secret_access_key="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")
        s3.Bucket(bucket_name).upload_file(zip_path, "packages/botobeak.zip")


if __name__ == "__main__":
    phiter = PhiterPackages()
    phiter.download_repo()
    phiter.zip_folder()
    phiter.copy_zip_to_s3("phiter")
    shutil.rmtree(os.getcwd())


    




