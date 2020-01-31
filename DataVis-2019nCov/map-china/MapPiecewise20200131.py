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
data = data[0]['children']

#构造echarts数据
outall = ''
for single in data:
    #{ name: '湖北', value:4586 },
    outstr = '\t\t{ name: \'' + single['name'] + '\', value: '+str(single['total']['confirm'])+' },\n'
    outall = outall +outstr

# 读取图形模板HTML
fid = open('MapPiecewise20200131temp.html','rb')
oriHtml = fid.read().decode('utf-8')
fid.close()

# 输出导入数据后的HTML
oriHtml = oriHtml.replace('//insertData//',outall)
fid = open('MapPiecewise20200131Modified.html','wb')
oriHtml = fid.write(oriHtml.encode('utf-8'))
fid.close()


