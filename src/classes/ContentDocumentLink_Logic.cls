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
                StampPredictCallOut(ip.Id);
            }
        }
        
    }
    
    @future(callout=true)
    public static void StampPredictCallOut(Id inspectionId) {
        System.debug('@@@ StampPredictCallOut()');
        System.debug('*** inspectionId ' + inspectionId);
        
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
        
        String url = getImageUrlFromCDLink(inspectionId);
        
        Einstein_Helper.predictImageDetectionURL(modelId, url);
        
    }
    
    public static String getImageUrlFromCDLink(Id recordId) {
        System.debug('@@@ getImageURLFromCDLink()');
        List<ContentDocumentLink> cdl = [SELECT Id, LinkedEntityId, ContentDocumentId, IsDeleted, SystemModstamp, ShareType, Visibility FROM ContentDocumentLink WHERE LinkedEntityId=:recordId  ORDER BY SystemModstamp DESC];
        List<ContentDocument> cd = [SELECT Id, LatestPublishedVersionId, PublishStatus, Title FROM ContentDocument WHERE Id=:cdl[0].ContentDocumentId];
        List<ContentVersion> cv = [SELECT FirstPublishLocationId, Id, Title, IsLatest, CreatedDate FROM ContentVersion WHERE Id=:cd[0].LatestPublishedVersionId AND IsLatest=true];
        if (cv.size()>0) {
            ContentDistribution cDist = new ContentDistribution();
            cDist.Name = 'Auto Create By Trigger';
            cDist.ContentVersionId = cv[0].Id;
            cDist.PreferencesNotifyOnVisit = false;
            List<ContentDistribution> existCDistList = [SELECT Id, ContentVersionId, ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId = :cv[0].Id];
            for(ContentDistribution existCDist :existCDistList){
                System.debug('*** existCDist ' + existCDist);
            }
            if(existCDistList.isEmpty()){
                insert cDist;
                cDist = [SELECT Id, ContentDownloadUrl FROM ContentDistribution WHERE Id=:cDist.Id];
                System.debug('*** cDist.ContentDownloadUrl ' + cDist.ContentDownloadUrl);
                return cDist.ContentDownloadUrl;
            }else{
                System.debug('*** existCDistList[0].ContentDownloadUrl ' + existCDistList[0].ContentDownloadUrl);
                return existCDistList[0].ContentDownloadUrl;
            }
        }
        return null;
    }
    
}