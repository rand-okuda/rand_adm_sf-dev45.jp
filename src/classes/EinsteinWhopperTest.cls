@isTest
private class EinsteinWhopperTest {
    
    @isTest
    static void UnitTest010() {
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        Einstein_PredictionResult result = service.predictImageBase64('YCQ4ZACEPJFGXZNRA6ERF3GL5E', 'aaabbbccc', 0, '');
        String label = 'XXX';
        Double probability = 0.1;
        result.filter(label, probability);
    }
    
    @isTest
    static void UnitTest011() {
        Einstein_JWT jwt = new Einstein_JWT('a');
        jwt.iss = 'b';
        jwt.sub = 's';
        jwt.aud = 'c';
        jwt.exp = 'd';
        jwt.iat = 'e';
        jwt.validFor = 1;
        jwt.cert = 'f';
        jwt.pkcs8 = 'g';
        jwt.privateKey = 'h';
        jwt.issue();
        Blob input = Blob.valueOf('XXX');
        jwt.base64URLencode(input);
    }
    
    @isTest
    static void UnitTest012() {
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        Einstein_PredictionService service = new Einstein_PredictionService(Einstein_PredictionService.Types.IMAGE);
        service.createDatasetFromUrlSync('https://myurl');
        service.createDatasetFromUrlAsync('https://myurl');
        service.getDataset(57);
        service.getGlobalDatasets();
        service.deleteDataset(108);
        service.createExample(57, '77880132.jpg', 614, Blob.valueOf('data'));
        service.createExamplesFromUrl(1000022, 'http://my.image.com/test.png');
        Blob theBlob = Blob.valueof('somedata');
        service.setType(Einstein_PredictionService.Types.IMAGE);
        service.createFeedbackImageExample('name', 'expectedLabel', 'modelId', theBlob);
        service.createFeedbackLanguageExample('expectedLabel', 'modelId', 'text');
        service.getExamples(57);
        service.trainDataset(57, 'Beach and Mountain Model', 0, 0, null);
        Einstein_TrainParams trainParams = new Einstein_TrainParams();
        trainParams.withFeedback = true;
        service.retrainDataset('modelId', 3, 0.001, trainParams);
        service.getModels(57);
        service.getModel('7JXCXTRXTMNLJCEF2DR5CJ46QU');
        service.getModelLearningCurve('7JXCXTRXTMNLJCEF2DR5CJ46QU');
        service.getModelMetrics('7JXCXTRXTMNLJCEF2DR5CJ46QU');
        service.detectImageBase64('YCQ4ZACEPJFGXZNRA6ERF3GL5E', 'aaabbbccc', 0, '');
        service.detectImageBlob('YCQ4ZACEPJFGXZNRA6ERF3GL5E', Blob.valueof('somedata'), 0, '');
        service.detectImageUrl('YCQ4ZACEPJFGXZNRA6ERF3GL5E', 'aaabbbccc', 0, '');
        service.predictImageBlob('modelId', Blob.valueof('somedata'), 0, 'sampleId');
        service.predictImageUrl('YCQ4ZACEPJFGXZNRA6ERF3GL5E', 'https://theurl', 0, '');
        service.getApiUsage();
        
    }
    
    @isTest
    static void UnitTest013() {
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.SENTIMENT);
        Einstein_PredictionResult result = service.predictSentiment('modelId', 'text', 0, '');
        service.setType(Einstein_PredictionService.Types.INTENT);
        result = service.predictIntent('modelId', 'text', 0, '');
    }
    
    @isTest
    static void UnitTest014() {
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        Einstein_PredictionService service = new Einstein_PredictionService(Einstein_PredictionService.Types.IMAGE);
    }
    
}