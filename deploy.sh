    # deploy.sh
    lambda=${1%/};
    echo "Running bundle install deployment";
    docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 bundle install --deployment
    if [ $? -eq 0 ]; then
      echo "done";
    else
      echo "bundle install failed";
      exit 1;
    fi
    echo "removing old build"
    rm build.zip;
    echo "creating a new build file"
    zip build.zip *  -r -x .git/\* \*.sh specs/\* tests/\* \*.zip
    echo "Uploading $lambda";
    aws lambda update-function-code --function-name $lambda --zip-file fileb://build.zip --region=us-east-1 --publish
    if [ $? -eq 0 ]; then
      echo "## Deploy successful ##"
    else
      echo "Deploy failed for = $lambda"
      exit 1;
    fi