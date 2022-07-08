
codeunit 50111 "MyJobQueueEntrySubscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Job Queue Entry", 'OnAfterGetXmlContent', '', false, false)]
    procedure OnAfterGetXmlContent(var JobQueueEntry: Record "Job Queue Entry"; var Params: Text)
    begin
        if Params <> '' then
            UpdateParams(Params,JobQueueEntry."Object ID to Run");
    end;

    procedure UpdateParams(var Params: Text; ReportId: integer)
    var
        xmlDoc: XmlDocument;
        rootElement: XmlElement;
        parametersNode: XmlNode;
        lowLevelNode : XmlNode;
        parametersAttribute : XmlAttribute;
        nodeList : XmlNodeList;
        oldInnerText : Text;
        newInnerText : Text;
        jobQueueRepFieldSub: Record "Job Queue Report Field Subst.";
    begin

        jobQueueRepFieldSub.SetRange("Report ID",ReportId);
        if jobQueueRepFieldSub.FindSet(false,false) then repeat
            
            Clear(xmlDoc);
            Clear(parametersNode);
            Clear(rootElement);
            Clear(lowLevelNode);

            if not XmlDocument.ReadFrom(Params, xmlDoc) then
                exit;
            if not xmlDoc.GetRoot(rootElement) then
                exit;

            foreach parametersNode in rootElement.GetChildNodes() do begin
                case jobQueueRepFieldSub."Job Queue Report Field Type" of
                    "Job Queue Report Field Type"::"Data Item Filter":
                        begin
                            if parametersNode.SelectNodes('DataItem',nodeList) then begin
                                foreach lowLevelNode in nodeList do begin
                                    if lowLevelNode.AsXmlElement().Attributes().Get('name',parametersAttribute) then begin
                                        if Format(parametersAttribute.Value) = jobQueueRepFieldSub."Name" then begin
                                            oldInnerText := lowLevelNode.AsXmlElement().InnerText;
                                            newInnerText := ChangeDataItemInnerText(oldInnerText,jobQueueRepFieldSub."Req. Page Field Id",jobQueueRepFieldSub."Substitute Value");
                                            if oldInnerText <> newInnerText then
                                                Params := Params.Replace(oldInnerText,newInnerText);
                                            //Message(Params);
                                        end;
                                    end;
                                end;    
                            end;
                        end;    
                    "Job Queue Report Field Type"::Option:
                        begin
                            if parametersNode.SelectNodes('Field',nodeList) then begin
                                foreach lowLevelNode in nodeList do begin
                                    if lowLevelNode.AsXmlElement().Attributes().Get('name',parametersAttribute) then begin
                                        if Format(parametersAttribute.Value) = jobQueueRepFieldSub."Name" then begin
                                            oldInnerText := lowLevelNode.AsXmlElement().InnerText;
                                            if oldInnerText <> '' then 
                                                Params := Params.Replace('name="' + jobQueueRepFieldSub.Name + '">' + oldInnerText + '</Field>',
                                                    'name="' + jobQueueRepFieldSub.Name + '">' + ConvertDate(jobQueueRepFieldSub."Substitute Value") + '</Field>');
                                            //Message(Params);
                                        end;
                                    end;
                                end;    
                            end;
                        end;    
                end;
            end;

        until jobQueueRepFieldSub.Next() = 0;

        
    end;

    local procedure ChangeDataItemInnerText(innerText : Text; fieldId : Integer; substituteValue : Enum "Job Queue Report Field Subst.") : Text
    var
        originalDateText: Text;
        fieldValue : Text;
        fieldPos: Integer;
        commaPos: Integer;
        minusPos : Integer;
    begin
        fieldValue := 'Field' + Format(fieldId);
        fieldPos := StrPos(innerText,fieldValue);
        if fieldPos > 0 then 
            originalDateText := CopyStr(innerText,fieldPos + StrLen(fieldValue))
        else
            exit(innerText);

        commaPos := StrPos(originalDateText,',');
        if commaPos > 0 then
            originalDateText := CopyStr(originalDateText,1,commaPos);

        minusPos := StrPos(originalDateText,'-');
        if minusPos > 5 then
            originalDateText := CopyStr(originalDateText,minusPos - 4,10)
        else
            exit(innerText);

        exit(innerText.Replace(originalDateText,ConvertDate(substituteValue)));
    end;

    local procedure ConvertDate(substituteValue : Enum "Job Queue Report Field Subst.") : text[10]
    var
        processingDate : Date;
        dateString : Text[10];        
    begin
        case substituteValue of
            substituteValue::TODAY: processingDate := Today();
            substituteValue::WORKDATE: processingDate := WorkDate();
            else
                exit('');
        end;

        datestring := format(Date2DMY(processingDate,3)) + '-' + 
            format(Date2DMY(processingDate,2)).PadLeft(2,'0') + '-' + 
            format(Date2DMY(processingDate,1)).PadLeft(2,'0');
        exit(dateString); 
    end;

}
