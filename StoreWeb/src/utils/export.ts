import FileSaver from "file-saver";
import * as XLSX from "xlsx";

/**
 * 导出表格数据为 Excel 文件
 * @param id - 表格选择器，例如类名使用 ".class"，ID 使用 "#id"
 * @param title - 要导出的 Excel 文件名（不包含扩展名）
 * @returns 生成的 Excel 文件数据
 */
export const exportTable = (id: string, title: string): Uint8Array => {
  // 获取并克隆要导出的表格元素
  const tableElement = document.querySelector(id);
  
  if (!tableElement) {
    throw new Error(`未找到选择器为 "${id}" 的表格元素`);
  }
  
  const table = tableElement.cloneNode(true) as HTMLElement;
  
  // 处理 Element UI 表格的 fixed 列问题
  // 移除右侧固定列
  const rightFixed = table.querySelector(".el-table__fixed-right");
  if (rightFixed && rightFixed.parentNode) {
    rightFixed.parentNode.removeChild(rightFixed);
  }
  
  // 移除左侧固定列
  const leftFixed = table.querySelector(".el-table__fixed");
  if (leftFixed && leftFixed.parentNode) {
    leftFixed.parentNode.removeChild(leftFixed);
  }

  try {
    // 将表格转换为 workbook
    const wb: XLSX.WorkBook = XLSX.utils.table_to_book(table, {
      raw: true
    });

    // 生成 Excel 文件数据
    const wbout: Uint8Array = XLSX.write(wb, {
      bookType: "xlsx",
      bookSST: true,
      type: "array",
    });

    // 保存文件
    const blob = new Blob([wbout], {
      type: "application/octet-stream"
    });
    
    FileSaver.saveAs(blob, `${title}.xlsx`);

    return wbout;
  } catch (error) {
    // 增强错误处理
    if (typeof console !== "undefined") {
      console.error("导出 Excel 文件时出错:", error);
    }
    throw error; // 重新抛出错误，让调用者可以处理
  }
};

// 如果需要默认导出
export default exportTable;