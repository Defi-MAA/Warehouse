import { DirectiveBinding } from 'vue';

interface DragData {
  type: 'new-widget' | 'move-widget';
  widgetType?: WidgetType;
  widgetId?: string;
  bandId?: string;
  offsetX?: number;
  offsetY?: number;
}

export const vDraggable = {
  mounted(el: HTMLElement, binding: DirectiveBinding) {
    el.setAttribute('draggable', 'true');
    
    el.addEventListener('dragstart', (e: DragEvent) => {
      const data: DragData = binding.value;
      e.dataTransfer!.setData('text/plain', JSON.stringify(data));
      e.dataTransfer!.effectAllowed = 'copy';
      
      // 如果是移动已有控件，记录鼠标相对控件的位置
      if (data.type === 'move-widget') {
        const rect = el.getBoundingClientRect();
        data.offsetX = e.clientX - rect.left;
        data.offsetY = e.clientY - rect.top;
        e.dataTransfer!.setData('text/plain', JSON.stringify(data));
      }
      
      el.classList.add('dragging');
    });
    
    el.addEventListener('dragend', () => {
      el.classList.remove('dragging');
    });
  }
};

export const vDropzone = {
  mounted(el: HTMLElement, binding: DirectiveBinding) {
    el.addEventListener('dragover', (e: DragEvent) => {
      e.preventDefault();
      el.classList.add('drop-over');
    });
    
    el.addEventListener('dragleave', () => {
      el.classList.remove('drop-over');
    });
    
    el.addEventListener('drop', (e: DragEvent) => {
      e.preventDefault();
      el.classList.remove('drop-over');
      
      const rawData = e.dataTransfer!.getData('text/plain');
      if (!rawData) return;
      
      const dragData: DragData = JSON.parse(rawData);
      const bandId = binding.value.bandId;
      const rect = el.getBoundingClientRect();
      
      // 计算放置位置 (相对于band)
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      
      // 调用回调，传递放置信息
      if (binding.value.onDrop) {
        binding.value.onDrop({ dragData, bandId, position: { x, y } });
      }
    });
  }
};