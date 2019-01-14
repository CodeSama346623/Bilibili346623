function ToPrXML(timestamp,xmlfilename)
%% 写入XML
%创建根结点
global docNode
docNode = com.mathworks.xml.XMLUtils.createDocument('xmeml');
docRootNode = docNode.getDocumentElement;
docRootNode.setAttribute('version','4');
% 创建sequence元素
thisElement = docNode.createElement('sequence');
% duration
newElement=docNode.createElement('duration');
newElement.appendChild(docNode.createTextNode('0'));
thisElement.appendChild(newElement);
% rate
newElement=docNode.createElement('rate');
newEle2=docNode.createElement('timebase');
newEle2.appendChild(docNode.createTextNode('30'));
newElement.appendChild(newEle2);
newEle2=docNode.createElement('ntsc');
newEle2.appendChild(docNode.createTextNode('TRUE'));
newElement.appendChild(newEle2);
thisElement.appendChild(newElement);
%% name
newElement=docNode.createElement('name');
newElement.appendChild(docNode.createTextNode('series02'))
thisElement.appendChild(newElement)

%% media
newElement = docNode.createElement('media');
    %% video
    videoEle=docNode.createElement('video');
        % format
        formatEle=docNode.createElement('format');
        formatEle.appendChild(createSample());
        videoEle.appendChild(formatEle);
        % track
        trackEle= docNode.createElement('track');
         
        % 添加视频
        for i=1:size(timestamp)
          tstart=num2str(timestamp(i));
          tend=num2str(timestamp(i)+8);
          % 创建视频片段 
          clipitemEle = addClipItemVideo('001','007',tstart,tend,'0','8');
          trackEle.appendChild(clipitemEle);        
        end
        
        trackEle.appendChild(creEle('enabled','TRUE'));
        trackEle.appendChild(creEle('locked','FALSE'));        
        videoEle.appendChild(trackEle);
    newElement.appendChild(videoEle);
    
    
    %% audio
    audioEle=docNode.createElement('audio');
        %numOutputChannels    
        audioEle.appendChild(creEle('numOutputChannels','2'));
        %format
        formatEle=docNode.createElement('format');
            samEle=docNode.createElement('samplecharacteristics');
            samEle.appendChild(creEle('depth','16'));
            samEle.appendChild(creEle('samplerate','44100'));
        formatEle.appendChild(samEle);
        audioEle.appendChild(formatEle);
        
     %%% BGM track1
     trackEle= docNode.createElement('track');
     trackEle.setAttribute('PannerCurrentValue',  '0.5');
     trackEle.setAttribute('currentExplodedTrackIndex',  '0');
     trackEle.setAttribute('totalExplodedTrackCount',  '2');   
     trackEle.setAttribute('premiereTrackType',  'Stereo');
     % 添加BGM音轨 1
     clipitemEle2 = addClipItemAudioBGM('003','009','1',1,  '0','433','0','433');     
     trackEle.appendChild(clipitemEle2);
     
     trackEle.appendChild(creEle('enabled','TRUE'));
     trackEle.appendChild(creEle('locked','FALSE'));
     trackEle.appendChild(creEle('outputchannelindex','1'));
     audioEle.appendChild(trackEle);
     %%% end of track1    

     %%% BGM track2
     trackEle= docNode.createElement('track');
     trackEle.setAttribute('PannerCurrentValue',  '0.5');
     trackEle.setAttribute('currentExplodedTrackIndex',  '1');
     trackEle.setAttribute('totalExplodedTrackCount',  '2');   
     trackEle.setAttribute('premiereTrackType',  'Stereo');   
     % 添加BGM音轨 2    
     clipitemEle2 = addClipItemAudioBGM('003','009','1',1, '0','433','0','433');
     trackEle.appendChild(clipitemEle2);
     
     trackEle.appendChild(creEle('enabled','TRUE'));
     trackEle.appendChild(creEle('locked','FALSE'));
     trackEle.appendChild(creEle('outputchannelindex','2'));
     audioEle.appendChild(trackEle);
     %%% end of track2  
            
     %%% Gun track3
     trackEle= docNode.createElement('track');
     trackEle.setAttribute('PannerCurrentValue',  '0.5');
     trackEle.setAttribute('currentExplodedTrackIndex',  '0');
     trackEle.setAttribute('totalExplodedTrackCount',  '2');   
     trackEle.setAttribute('premiereTrackType',  'Stereo');    
     % 添加枪声音轨
     for i=1:size(timestamp)
          tstart=num2str(timestamp(i));
          tend=num2str(timestamp(i)+8);
          clipitemEle3 = addClipItemAudioGun('002','007',1,tstart,tend,'0','8');     
          trackEle.appendChild(clipitemEle3);
     end
     
     trackEle.appendChild(creEle('enabled','TRUE'));
     trackEle.appendChild(creEle('locked','FALSE'));
     trackEle.appendChild(creEle('outputchannelindex','1'));
     audioEle.appendChild(trackEle);
     %%% end of track3     
    newElement.appendChild(audioEle);
thisElement.appendChild(newElement);

%% timecode
newElement = docNode.createElement('timecode');
% rate
newEle2 = docNode.createElement('rate');
newEle3 = docNode.createElement('timebase');
newEle3.appendChild(docNode.createTextNode('30'));
newEle2.appendChild(newEle3);
newEle3 = docNode.createElement('ntsc');
newEle3.appendChild(docNode.createTextNode('TRUE'));
newEle2.appendChild(newEle3);
newElement.appendChild(newEle2);
% string
newEle2 = docNode.createElement('string');
newEle2.appendChild(docNode.createTextNode('00;00;00;00'));
newElement.appendChild(newEle2);
% frame
newEle2 = docNode.createElement('frame');
newEle2.appendChild(docNode.createTextNode('0'));
newElement.appendChild(newEle2);
%displayformat
newEle2 = docNode.createElement('displayformat');
newEle2.appendChild(docNode.createTextNode('DF'));
newElement.appendChild(newEle2);
% add timecode
thisElement.appendChild(newElement);

docRootNode.appendChild(thisElement);
%添加注释
docNode.appendChild(docNode.createComment('感谢“玄武子元”大佬2019年1月充电支持！感谢Sherlock酱陪我唠嗑！'))
% 输出XML文件
xmlwrite(xmlfilename,docNode)
end

function [rootEle] = createSample()
% 视频特征部分 Video Sample Characteristics
global docNode
 rootEle=docNode.createElement('samplecharacteristics');
 % rate
 rateEle = docNode.createElement('rate');
    newEle=docNode.createElement('timebase');
    newEle.appendChild(docNode.createTextNode('30'))
    rateEle.appendChild(newEle)
rootEle.appendChild(rateEle)
% width
widthEle = docNode.createElement('width');
    widthEle.appendChild(docNode.createTextNode('1280'))
rootEle.appendChild(widthEle)
% height
widthEle = docNode.createElement('height');
    widthEle.appendChild(docNode.createTextNode('720'))
rootEle.appendChild(widthEle)
% pixelaspectratio
widthEle = docNode.createElement('pixelaspectratio');
    widthEle.appendChild(docNode.createTextNode('square'))
rootEle.appendChild(widthEle)
% colordepth
widthEle = docNode.createElement('colordepth');
    widthEle.appendChild(docNode.createTextNode('24'))
rootEle.appendChild(widthEle)
end

function [rootEle] = creEle(EleName,EleValue)
% 含有文字节点的元素创建
global docNode
rootEle= docNode.createElement(EleName);
rootEle.appendChild(docNode.createTextNode(EleValue));
end

function [rootEle] = addClipItemVideo(id,mid, tStart, tEnd, tIn, tOut)
%  添加视频片段
global docNode
rootEle= docNode.createElement('clipitem');
rootEle.setAttribute('id',['clipitem-' id]);
rootEle.appendChild(creEle('masterclipid',['masterclip-' mid ]));
rootEle.appendChild(creEle('name','sub001.mp4'));
rootEle.appendChild(creEle('enabled','TRUE'));
rootEle.appendChild(creEle('duration','28'));
    rateEle=docNode.createElement('rate');
        rateEle.appendChild(creEle('timebase','30'));
        rateEle.appendChild(creEle('ntsc','TRUE'));
 rootEle.appendChild(rateEle);
 % 设置视频在剪辑序列中的起止点
 rootEle.appendChild(creEle('start',tStart));
 rootEle.appendChild(creEle('end',tEnd));
 %设置视频播放在视频源的出入点
 rootEle.appendChild(creEle('in',tIn));
 rootEle.appendChild(creEle('out',tOut));
 
 rootEle.appendChild(creEle('pixelaspectratio','square'));
 fileEle=docNode.createElement('file');
     fileEle.setAttribute('id', ['file-' mid])
     fileEle.appendChild(creEle('name','sub001.mp4'));
     %%% 文件路径
     fileEle.appendChild(creEle('pathurl','file://localhost/C%3a/Users/wdnin/Videos/Matlab%20Music/VADXML/sub001.mp4'));
        rateEle=docNode.createElement('rate');
        rateEle.appendChild(creEle('timebase','30'));
        rateEle.appendChild(creEle('ntsc','FALSE'));
        fileEle.appendChild(rateEle)
 fileEle.appendChild(creEle('duration','28'));
     mediaEle=docNode.createElement('media');
        videoEle = docNode.createElement('video');
            sampleEle = docNode.createElement('samplecharacteristics');
                rateEle = docNode.createElement('rate');
                    rateEle.appendChild(creEle('timebase','30'));
                    rateEle.appendChild(creEle('ntsc','FALSE'));
            sampleEle.appendChild(rateEle);
            sampleEle.appendChild(creEle('width','1280'));
            sampleEle.appendChild(creEle('height','720'));
            sampleEle.appendChild(creEle('anamorphic','FALSE'));
            sampleEle.appendChild(creEle('pixelaspectratio','square'));
            sampleEle.appendChild(creEle('fielddominance','none'));
        videoEle.appendChild(sampleEle);
        mediaEle.appendChild(videoEle);        
    audioEle = docNode.createElement('audio');
        sampleEle = docNode.createElement('samplecharacteristics');
            sampleEle.appendChild(creEle('depth','16'));
            sampleEle.appendChild(creEle('samplerate','48000')); 
     audioEle.appendChild(sampleEle);
     audioEle.appendChild(creEle('channelcount','2'));     
     mediaEle.appendChild(audioEle);   
fileEle.appendChild(mediaEle);
rootEle.appendChild(fileEle);     
end

function [rootEle] = addClipItemAudioBGM(id,mid,trackid,mediaflag, tStart, tEnd, tIn, tOut)
%  添加BGM音轨
global docNode
rootEle= docNode.createElement('clipitem');
rootEle.setAttribute('id',['clipitem-' id]);
rootEle.setAttribute('premiereChannelType','stereo');
    rootEle.appendChild(creEle('masterclipid', ['masterclip-' mid]))
    rootEle.appendChild(creEle('name','BadAppleClip.mp3'))
    rootEle.appendChild(creEle('enabled','TRUE'))
    rootEle.appendChild(creEle('duration','433'))
        rateEle=docNode.createElement('rate');
        rateEle.appendChild(creEle('timebase','30'));
        rateEle.appendChild(creEle('ntsc','TRUE'));
        rootEle.appendChild(rateEle);
     % 设置BGM音轨在剪辑序列中的起止点   
     rootEle.appendChild(creEle('start',tStart));
     rootEle.appendChild(creEle('end',tEnd));
     % 设置BGM音轨在BGM中的出入点 
     rootEle.appendChild(creEle('in',tIn));
     rootEle.appendChild(creEle('out',tOut));     
     
     fileEle=docNode.createElement('file');
     fileEle.setAttribute('id', ['file-' mid ]);
     fileEle.appendChild(creEle('name','BadAppleClip.mp3'))
     %%% 设置文件路径
     fileEle.appendChild(creEle('pathurl','file://localhost/C%3a/Users/wdnin/Videos/Matlab%20Music/VADXML/BadAppleClip.mp3'))
     rateEle=docNode.createElement('rate');
        rateEle.appendChild(creEle('timebase','30'));
        rateEle.appendChild(creEle('ntsc','TRUE'));
        fileEle.appendChild(rateEle);
        fileEle.appendChild(creEle('duration','433'))
        
     if mediaflag==1   
      mediaEle=docNode.createElement('media');
     
     audioEle = docNode.createElement('audio');
        sampleEle = docNode.createElement('samplecharacteristics');
            sampleEle.appendChild(creEle('depth','16'));
            sampleEle.appendChild(creEle('samplerate','44100'));            
     audioEle.appendChild(sampleEle);
     audioEle.appendChild(creEle('channelcount','2'));
     mediaEle.appendChild(audioEle);   
    fileEle.appendChild(mediaEle);
     end 
     
     rootEle.appendChild(fileEle);     
     sourceEle = docNode.createElement('sourcetrack');
     sourceEle.appendChild(creEle('mediatype', 'audio'));
     sourceEle.appendChild(creEle('trackindex', trackid));
     rootEle.appendChild(sourceEle);        
end

function [rootEle] = addClipItemAudioGun(id,mid,mediaflag, tStart, tEnd, tIn, tOut)
% 添加枪声音轨
global docNode
rootEle= docNode.createElement('clipitem');
rootEle.setAttribute('id',['clipitem-' id]);
rootEle.setAttribute('premiereChannelType','stereo');
    rootEle.appendChild(creEle('masterclipid', ['masterclip-' mid]))
    rootEle.appendChild(creEle('name','sub001.mp4'))
    rootEle.appendChild(creEle('enabled','TRUE'))
    rootEle.appendChild(creEle('duration','28'))
        rateEle=docNode.createElement('rate');
        rateEle.appendChild(creEle('timebase','30'));
        rateEle.appendChild(creEle('ntsc','TRUE'));
        rootEle.appendChild(rateEle);
     % 设置枪声音频在剪辑中的起止点   
     rootEle.appendChild(creEle('start',tStart));
     rootEle.appendChild(creEle('end',tEnd));
     % 设置枪声音频在音源中的出入点
     rootEle.appendChild(creEle('in',tIn));
     rootEle.appendChild(creEle('out',tOut)); 
     
     fileEle=docNode.createElement('file');
     fileEle.setAttribute('id', ['file-' mid ]);
     rootEle.appendChild(fileEle);     
     sourceEle = docNode.createElement('sourcetrack');
     sourceEle.appendChild(creEle('mediatype', 'audio'));
     sourceEle.appendChild(creEle('trackindex', '1'));
     rootEle.appendChild(sourceEle);        
end

