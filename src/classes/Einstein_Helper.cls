public class Einstein_Helper {
    
    public static Einstein_PredictionService service;
    
    private static void setType(String dataType) {
        if (service==null) {
            service = new Einstein_PredictionService(Einstein_PredictionService.Types.IMAGE);
        }
        if (dataType=='image') {
            service.setType(Einstein_PredictionService.Types.IMAGE);
        } else if (dataType=='image-detection') {
            service.setType(Einstein_PredictionService.Types.IMAGE_DETECTION);
        }
    }
    
    public static List<Einstein_Dataset> getDatasets(String dataType) {
        System.debug('@@@ getDatasets()');
        System.debug('*** dataType ' + dataType);
        setType(dataType);
        List<Einstein_Dataset> datasets = service.getDatasets();
        List<Einstein_Dataset> datasetsReturn = new List<Einstein_Dataset>();
        for (Einstein_Dataset dataset : datasets) {
            if (dataset.type==dataType) {
                datasetsReturn.add(dataset);
            }
        }
        if (service.httpStatusCode>200) {
            System.debug('*** service.httpErrorMessage ' + service.httpErrorMessage);
        }
        System.debug('*** datasetsReturn ' + datasetsReturn);
        for ( Integer i=0; i<datasetsReturn.size(); i++ ){
            System.debug('*** datasetsReturn.Id ' + datasetsReturn[i].Id);
            System.debug('*** datasetsReturn.Name ' + datasetsReturn[i].Name);
        }
        return datasetsReturn;
    }

    public static List<Einstein_Model> getModels(Long datasetId, String dataType) {
        System.debug('@@@ getModels()');
        System.debug('*** datasetId ' + datasetId);
        System.debug('*** dataType ' + dataType);
        setType(dataType);
        Einstein_Model[] models = service.getModels(datasetId);
        if (service.httpStatusCode>200) {
            System.debug('*** service.httpErrorMessage ' + service.httpErrorMessage);
        }
        System.debug('*** models ' + models);
        for ( Integer i=0; i<models.size(); i++ ){
            System.debug('*** models.modelId ' + models[i].modelId);
            System.debug('*** models.name ' + models[i].name);
            System.debug('*** models.modelType ' + models[i].modelType);
        }
        return models;
    }

    public static Einstein_PredictionResult predictImageDetectionURL(String modelId, String url) {
        System.debug('@@@ predictImageDetectionURL()');
        System.debug('*** modelId ' + modelId);
        System.debug('*** url ' + url);
        setType('');
        service.setType(Einstein_PredictionService.Types.IMAGE_DETECTION);
        Einstein_PredictionResult result = service.detectImageUrl(modelId, url, 0, '');
        if (service.httpStatusCode>200) {
            System.debug('*** service.httpErrorMessage ' + service.httpErrorMessage);
        }
        System.debug('*** result ' + result);
        for ( Integer i=0; i<result.probabilities.size(); i++ ){
            System.debug('*** result.probabilities.label ' + result.probabilities[i].label);
            System.debug('*** result.probabilities.probability ' + result.probabilities[i].probability);            
        }
        return result;
    }

}