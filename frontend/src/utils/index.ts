import * as  XLSX from 'xlsx';


export function getTokenIds(startTokenId: number, size: number) {
  return Array(size)
      .fill('')
      .map((element, index) => index + startTokenId);
}

export function downloadXlsx(columns: Array<string>, data: Array<any>, fileName: string) {
  //columns 表头 data文件数据列表 fileName文件名称
  let table = [];
  let obj:any = {};
  columns.forEach((el, index) => {
    let str = String.fromCharCode(index + 65);
    obj[str] = el
  })
  table.push(obj)
  data.forEach((arr) => {
    let row:any = {}
    arr.forEach((el: any, index: number) => {
      let str = String.fromCharCode(index + 65);
      row[str] = el
    })
    table.push(row);
  });
  //创建book
  let wb = XLSX.utils.book_new();
  //json转sheet
  let ws = XLSX.utils.json_to_sheet(table, { header: Object.keys(obj), skipHeader: true });
  //设置列宽
  ws['!cols'] = (new Array(Object.keys(obj).length)).fill({ width: 15 });
  //sheet写入book
  XLSX.utils.book_append_sheet(wb, ws, "file");
  //输出
  let name = fileName || "文件下载"
  XLSX.writeFile(wb, name + ".xlsx");
}
export function formatJson(filterVal: Array<string>, jsonData: Array<any>,) {
  return jsonData.map((v) =>
    v && Object.keys(v).length ? filterVal.map((j) => v[j] || '') : []
  );
}