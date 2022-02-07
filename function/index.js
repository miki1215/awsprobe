var AWS = require("aws-sdk");
var transcribeservice = new AWS.TranscribeService();
var params = {"TranscriptionJobName": "text1"  };
var response;

exports.handler = async (event,context) => {
    
         response=transcribeservice.getTranscriptionJob(params).promise();
         await response;
         let rr = response.then((data => response = (data.TranscriptionJob.Transcript.TranscriptFileUri)));
         return rr;
};