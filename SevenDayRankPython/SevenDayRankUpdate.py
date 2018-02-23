#coding:utf-8

import urlfetch
import json
import time
commentstr='''
23010532,山里一泼猴,Bilibili同桌,B站直播UP
5724886,隔壁街老王,经常串门的大佬,绿了一条街233
123870078,ChYFx_Christer,C#大佬,游戏视频UP
13726234,MrChinico,经常⁄(⁄ ⁄•⁄ω⁄•⁄ ⁄)⁄的大佬,约好做同桌
18107647,这里有蜘蛛°,给予鼓励的大佬,大佬头像很好看
5271069,盒饭工作室,B站直播UP,高考加油
20237217,SuperPaxxs,对直播撸码很惊讶的大佬,B站up
95113356,小火车车车,直播来了一次的大佬,后面就没见到了
24313542,B站人工机器人,第一个投喂亿元的大佬,给大佬拜年了
'''

htmlcard1='''
<div class="col-xs-3 text-center dalao #DalaoOrder#" >
    <h4><strong>#Uname#</strong></h4>
    <img class="img-thumbnail img-circle" src="#face#" alt="#Uname#" style="width:100%;">
    <div>
        <h4>#Comments#</h4>
        <p><strong>#Details#</strong></p>
    </div>
</div>
'''
htmlcard2='''
<div class="item #active#">
    <img class="img-thumbnail img-circle" src="#face#" alt="#Uname#">
    <div>
        <h4>#Uname#</h4>
        <p>#Comments#</p>
    </div>
</div>
'''
def getMyInfo():
    hdr={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36',
         'Host':'space.bilibili.com','Origin':'https://space.bilibili.com','Referer':'https://space.bilibili.com/9579763/'}
    url='https://space.bilibili.com/ajax/member/GetInfo'
    dat={'mid':'9579763'}
    res=urlfetch.post(url,headers=hdr,data=dat)
    if res.status==200:
        resstr=res.content
        #print resstr
        strjson=json.loads(resstr)
        return strjson
    else:
        return []
def getSevenDayRank():
    hdr={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36','Host':'api.live.bilibili.com'}
    url='https://api.live.bilibili.com/rankdb/v1/RoomRank/webSevenRank?roomid=346623&ruid=9579763'
    res=urlfetch.fetch(url,headers=hdr)
    if res.status==200:
        resstr=res.content
        strjson=json.loads(resstr)
        return strjson['data']['list']
    else:
        return []
def cardS1(rank,sevenrank,htmlcard1,comment1):
    card1=htmlcard1
    card1=card1.replace('#Uname#',sevenrank[rank]['uname'])
    card1=card1.replace('#face#',sevenrank[rank]['face'])
    card1=card1.replace('#DalaoOrder#','dalao'+str(rank+1))
##    #print sevenrank[rank]['uname'].encode('utf-8')
##    #print comment[str(sevenrank[rank]['uid'])][2].decode('utf-8')
##    print (comment1[str(sevenrank[rank]['uid'])][1])
##    print (comment1[str(sevenrank[rank]['uid'])][2])
    if (str(sevenrank[rank]['uid'])) in comment1: 
        card1=card1.replace('#Comments#',comment1[str(sevenrank[rank]['uid'])][1])
        card1=card1.replace('#Details#',comment1[str(sevenrank[rank]['uid'])][2])
    return card1
def cardS2(rank,sevenrank,htmlcard1,active,comment1):
    card1=htmlcard2
    card1=card1.replace('#Uname#',sevenrank[rank]['uname'])
    card1=card1.replace('#face#',sevenrank[rank]['face'])
    if (str(sevenrank[rank]['uid'])) in comment1:
        card1=card1.replace('#Comments#',comment1[str(sevenrank[rank]['uid'])][1])

    if active:
        card1=card1.replace('#active#','active')
    else:
        card1=card1.replace('#active#','')
    return card1
def commentParser(commentstr):
##    fid=open('comment.txt','rb')
##    fstr=fid.read().decode(encoding="utf-8")
##    fid.close()

    comment1=dict()
    #details=list()
    flist=commentstr.strip().split('\n')
##    flist=fstr.strip().split('\r\n')
    for single in flist:
        slist=single.split(',')
        print (slist)
        comment1[slist[0]]=[slist[1],slist[2],slist[3]];
        #print comment[slist[0]][0]
    return comment1

    
#print str(getSevenDayRank())
sevenrank=getSevenDayRank()
#print result[0]['uname']
comment1=commentParser(commentstr.decode('utf-8'))

section1=""
section1=section1+cardS1(0,sevenrank,htmlcard1,comment1)
section1=section1+cardS1(1,sevenrank,htmlcard1,comment1)
section1=section1+cardS1(2,sevenrank,htmlcard1,comment1)

section2=""
section2=section2+cardS2(3,sevenrank,htmlcard2,True,comment1)
for i in range(4,len(sevenrank)):
    section2=section2+cardS2(i,sevenrank,htmlcard2,False,comment1)

#print section1
#print section2
myInfo=getMyInfo();
fid=open('SevenDayRankTemplate.html','rb')
fstr=fid.read()
fid.close()
fstr=fstr.decode(encoding="utf-8")
fstr=fstr.replace("#Section1#",section1)
fstr=fstr.replace("#Section2#",section2)
fstr=fstr.replace('#ownface#',myInfo['data']['face'])
filename='SevenDayRank'+time.strftime("%Y%m%d",time.localtime())+'.html'
fid=open(filename,'wb')
fid.write(fstr.encode(encoding="utf-8"))
fid.close()


