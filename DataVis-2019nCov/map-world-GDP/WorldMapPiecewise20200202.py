import json
# 获取各各国GDP数据
data = list()
with open('GDPworldTop15.csv','r') as f:
    try:
        while True:
            readStr = f.readline()
            dataSpl = readStr.split(',')
            if readStr:
                data.append((dataSpl[0],dataSpl[1].strip()))            
            else:
                break

    finally:
        f.close()

# 读取国家名称中文转英文数据
with open('countryC2E.json','r',encoding = 'utf-8') as f:
    c2e = json.load(f)

# 构造echarts数据
outall = ''
for single in data:
    #print(single['name'], single['total'])
    outstr = '\t\t\t{ name: \'' + c2e[single[0]] + '\', value: '+single[1]+' },\n'
    outall = outall +outstr
print (outall)

# 读取图形模板HTML
fid = open('WorldMapPiecewise20200202temp.html','rb')
oriHtml = fid.read().decode('utf-8')
fid.close()
# 输出导入数据后的HTML
oriHtml = oriHtml.replace('//insertData//',outall)
fid = open('WorldMapPiecewise20200202Modified.html','wb')
oriHtml = fid.write(oriHtml.encode('utf-8'))
fid.close()


