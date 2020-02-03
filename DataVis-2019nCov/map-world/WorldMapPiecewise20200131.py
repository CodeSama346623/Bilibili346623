import urlfetch
import json
# 获取各省份统计数据
url = 'https://view.inews.qq.com/g2/getOnsInfo?name=disease_h5'
res = urlfetch.fetch(url)
resstr = res.content.decode('utf-8')

# JSON数据解析
jsonRes = json.loads(resstr)
data = jsonRes['data']
data = json.loads(data)['areaTree']

# 读取国家名称中文转英文数据
with open('countryC2E.json','r',encoding = 'utf-8') as f:
    c2e = json.load(f)
# 构造echarts数据
outall = ''
for single in data:
    #print(single['name'], single['total'])
    print (single['name'])
    print (c2e[single['name']])
    outstr = '\t\t\t{ name: \'' + c2e[single['name']] + '\', value: '+str(single['total']['confirm'])+' },\n'
    outall = outall +outstr

# 读取图形模板HTML
fid = open('WorldMapPiecewise20200131temp.html','rb')
oriHtml = fid.read().decode('utf-8')
fid.close()
# 输出导入数据后的HTML
oriHtml = oriHtml.replace('//insertData//',outall)
fid = open('WorldMapPiecewise20200131Modified.html','wb')
oriHtml = fid.write(oriHtml.encode('utf-8'))
fid.close()


