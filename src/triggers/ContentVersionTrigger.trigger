trigger ContentVersionTrigger on ContentVersion (after insert) {

    if(Trigger.isAfter && Trigger.isInsert){
        System.debug('%%%ContentVersionTrigger isAfter isInsert');
        List<ContentVersion> contentVersionList = new List<ContentVersion>();
        for(ContentVersion cv : Trigger.new){
            if(cv.PathOnClient != '/null.png' && cv.Origin == 'C' && cv.PublishStatus == 'P' && cv.FileType == 'PNG' || cv.FileType == 'JPG' || cv.FileType == 'JPEG' && cv.FileExtension == 'png' || cv.FileExtension == 'jpg' || cv.FileExtension == 'jpeg'){
                contentVersionList.add(cv);
            }
        }
        if(contentVersionList.size() > 0){
            ContentVersionLogic.QRcodeImageSearch(contentVersionList);
        }
    }

}