public class ContentDocumentLink_Logic {
    
    public static void StampPredict(List<ContentDocumentLink> targetCDLList) {
        System.debug('@@@ StampPredict()');
        
        Set<Id> LinkedEntityIdSet = new Set<Id>();
        for ( Integer i=0; i<targetCDLList.size(); i++ ){
            LinkedEntityIdSet.add(targetCDLList[i].LinkedEntityId);
            System.debug('*** targetCDLList[i] ' + targetCDLList[i]);
        }
        List<Inspection__c> existInspectionList = [SELECT Id FROM Inspection__c WHERE Id IN :LinkedEntityIdSet];
        
        if(!existInspectionList.isEmpty()){
            for(Inspection__c ip :existInspectionList){
                System.debug('*** ip ' + ip);
                String url = getImageUrlFromCDLink(ip.Id);
                if(url != null){
                    StampPredictCallOut(ip.Id, url);
                }
            }
        }
        
    }
    
    @future(callout=true)
    public static void StampPredictCallOut(Id inspectionId, String url) {
        System.debug('@@@ StampPredictCallOut()');
        System.debug('*** inspectionId ' + inspectionId);
        System.debug('*** url ' + url);
        
        String modelId;
        for(Einstein_Dataset ed :Einstein_Helper.getDatasets('image-detection')){
            if(ed.Name == 'OUIN'){
                System.debug('*** ed.id'  + ed.id);
                List<Einstein_Model> modelList = Einstein_Helper.getModels(ed.id, 'image-detection');
                modelId = modelList[0].modelId;
                System.debug('*** modelId ' + modelId);
                break;
            }
        }
        
        if(url != null && modelId != null){
            Einstein_PredictionResult result = Einstein_Helper.predictImageDetectionURL(modelId, url);
            Inspection__c ip = [SELECT Id, OUINConfirm__c FROM Inspection__c WHERE Id = :inspectionId];
            ip.OUINConfirm__c = result.probabilities[0].label;
            update ip;            
        }
        
    }
    
    public static String getImageUrlFromCDLink(Id recordId) {
        System.debug('@@@ getImageURLFromCDLink()');
        List<ContentDocumentLink> cdlList = [SELECT Id, LinkedEntityId, ContentDocumentId, IsDeleted, SystemModstamp, ShareType, Visibility FROM ContentDocumentLink WHERE LinkedEntityId=:recordId  ORDER BY SystemModstamp DESC];
        if(!cdlList.isEmpty()){
            String excludeTitle = String.valueOf(recordId).substring(0, 15);
            System.debug('*** excludeTitle ' + excludeTitle);
            List<ContentDocument> cdList = [SELECT Id, LatestPublishedVersionId, PublishStatus, Title, FileType, FileExtension FROM ContentDocument WHERE Id=:cdlList[0].ContentDocumentId AND Title != :excludeTitle AND FileType IN ('PNG','JPG','JPEG') AND FileExtension IN ('png','jpg','jpeg')];
            if(!cdList.isEmpty()){
                List<ContentVersion> cvList = [SELECT FirstPublishLocationId, Id, Title, IsLatest, CreatedDate FROM ContentVersion WHERE Id=:cdList[0].LatestPublishedVersionId AND IsLatest=true];
                if (!cvList.isEmpty()) {
                    ContentDistribution cDist = new ContentDistribution();
                    cDist.Name = 'Auto Create By Trigger';
                    cDist.ContentVersionId = cvList[0].Id;
                    cDist.PreferencesNotifyOnVisit = false;
                    List<ContentDistribution> existCDistList = [SELECT Id, ContentVersionId, ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId = :cvList[0].Id];
                    for(ContentDistribution existCDist :existCDistList){
                        System.debug('*** existCDist ' + existCDist);
                    }
                    if(!existCDistList.isEmpty()){
                        System.debug('*** existCDistList[0].ContentDownloadUrl ' + existCDistList[0].ContentDownloadUrl);
                        return existCDistList[0].ContentDownloadUrl;
                    }
                }
            }
        }
        return null;
    }
    
}