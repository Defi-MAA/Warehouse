<template>
    <div class="custom-image-upload">
      <!-- 上传区域 -->
      <el-upload
        v-if="!imageUrl"
        :action="action"
        :headers="headers"
        :name="name"
        :data="data"
        :with-credentials="withCredentials"
        :show-file-list="false"
        :on-success="handleSuccess"
        :on-error="handleError"
        :before-upload="beforeUpload"
        :accept="accept"
        :limit="1"
        class="upload-area"
      >
        <div class="upload-content">
          <el-icon><Plus /></el-icon>
          <div class="upload-text">{{ uploadText }}</div>
          <div v-if="tip" class="upload-tip">{{ tip }}</div>
        </div>
      </el-upload>
  
      <!-- 预览区域 -->
      <div v-else class="preview-area">
        <el-image
          :src="imageUrl"
          :fit="fit"
          :preview-src-list="[imageUrl]"
          preview-teleported
          class="preview-image"
        >
          <template #error>
            <div class="image-error">
              <el-icon><Picture /></el-icon>
              <span>加载失败</span>
            </div>
          </template>
        </el-image>
        
        <!-- 操作按钮组 -->
        <div class="preview-actions">
          <el-tooltip content="预览" placement="top">
            <el-button 
              type="primary" 
              circle 
              size="small" 
              @click="handlePreview"
            >
              <el-icon><View /></el-icon>
            </el-button>
          </el-tooltip>
          
          <el-tooltip content="重新上传" placement="top">
            <el-button 
              type="warning" 
              circle 
              size="small" 
              @click="handleReupload"
            >
              <el-icon><Refresh /></el-icon>
            </el-button>
          </el-tooltip>
          
          <el-tooltip content="删除" placement="top">
            <el-button 
              type="danger" 
              circle 
              size="small" 
              @click="handleDelete"
            >
              <el-icon><Delete /></el-icon>
            </el-button>
          </el-tooltip>
        </div>
      </div>
  
      <!-- 上传进度提示 -->
      <el-progress
        v-if="uploading"
        :percentage="uploadProgress"
        :status="uploadStatus"
        class="upload-progress"
      />
    </div>
  </template>
  
  <script setup>
  import { ref, computed } from 'vue'
  import { ElMessage, ElMessageBox } from 'element-plus'
  import { Plus, View, Refresh, Delete, Picture } from '@element-plus/icons-vue'
  
  const props = defineProps({
    // 组件值
    modelValue: {
      type: String,
      default: ''
    },
    // 上传地址
    action: {
      type: String,
      required: true
    },
    // 上传文件名
    name: {
      type: String,
      default: 'file'
    },
    // 额外参数
    data: {
      type: Object,
      default: () => ({})
    },
    // 请求头
    headers: {
      type: Object,
      default: () => ({})
    },
    // 是否携带cookie
    withCredentials: {
      type: Boolean,
      default: false
    },
    // 接受的文件类型
    accept: {
      type: String,
      default: 'image/*'
    },
    // 上传文本
    uploadText: {
      type: String,
      default: '点击上传图片'
    },
    // 提示文本
    tip: {
      type: String,
      default: '建议尺寸：200*200px'
    },
    // 图片填充方式
    fit: {
      type: String,
      default: 'cover'
    },
    // 最大文件大小（MB）
    maxSize: {
      type: Number,
      default: 5
    }
  })
  
  const emit = defineEmits(['update:modelValue', 'success', 'error', 'remove'])
  
  // 状态
  const uploading = ref(false)
  const uploadProgress = ref(0)
  const uploadStatus = ref('')
  const imageUrl = computed({
    get: () => props.modelValue,
    set: (val) => emit('update:modelValue', val)
  })
  
  // 上传前校验
  const beforeUpload = (file) => {
    const isImage = file.type.startsWith('image/')
    const isLtMaxSize = file.size / 1024 / 1024 < props.maxSize
  
    if (!isImage) {
      ElMessage.error('只能上传图片文件！')
      return false
    }
    
    if (!isLtMaxSize) {
      ElMessage.error(`图片大小不能超过 ${props.maxSize}MB！`)
      return false
    }
  
    uploading.value = true
    uploadProgress.value = 0
    uploadStatus.value = ''
    return true
  }
  
  // 上传成功
  const handleSuccess = (response, file, fileList) => {
    uploading.value = false
    uploadProgress.value = 100
    uploadStatus.value = 'success'
    
    // 根据你的接口返回结构调整
    const url = response.data?.url || response.url || response
    imageUrl.value = url
    
    ElMessage.success('上传成功！')
    emit('success', response, file)
  }
  
  // 上传失败
  const handleError = (error, file) => {
    uploading.value = false
    uploadStatus.value = 'exception'
    ElMessage.error('上传失败，请重试！')
    emit('error', error, file)
  }
  
  // 预览图片
  const handlePreview = () => {
    if (imageUrl.value) {
      ElMessageBox.alert(
        h('img', {
          src: imageUrl.value,
          style: {
            maxWidth: '100%',
            maxHeight: '70vh',
            display: 'block',
            margin: '0 auto'
          }
        }),
        '图片预览',
        {
          dangerouslyUseHTMLString: false,
          showConfirmButton: false,
          showCancelButton: true,
          cancelButtonText: '关闭',
          center: true
        }
      )
    }
  }
  
  // 重新上传
  const handleReupload = () => {
    imageUrl.value = ''
    emit('remove')
  }
  
  // 删除图片
  const handleDelete = () => {
    ElMessageBox.confirm('确定删除这张图片吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      imageUrl.value = ''
      emit('remove')
      ElMessage.success('删除成功！')
    }).catch(() => {})
  }
  
  // 模拟进度（如果需要的话）
  const handleProgress = (event, file, fileList) => {
    if (event.percent) {
      uploadProgress.value = Math.floor(event.percent)
    }
  }
  </script>
  
  <style scoped>
  .custom-image-upload {
    width: 100%;
    max-width: 300px;
  }
  
  .upload-area {
    display: block;
  }
  
  .upload-content {
    width: 200px;
    height: 200px;
    border: 1px dashed #d9d9d9;
    border-radius: 8px;
    background: #fafafa;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    transition: all 0.3s;
  }
  
  .upload-content:hover {
    border-color: #409eff;
    background: #f5f7fa;
  }
  
  .upload-content .el-icon {
    font-size: 28px;
    color: #8c939d;
    margin-bottom: 8px;
  }
  
  .upload-text {
    color: #606266;
    font-size: 14px;
  }
  
  .upload-tip {
    color: #909399;
    font-size: 12px;
    margin-top: 8px;
  }
  
  .preview-area {
    position: relative;
    width: 200px;
    height: 200px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  }
  
  .preview-image {
    width: 100%;
    height: 100%;
  }
  
  .image-error {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: #f5f7fa;
    color: #909399;
  }
  
  .preview-actions {
    position: absolute;
    bottom: 10px;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    gap: 8px;
    background: rgba(255, 255, 255, 0.9);
    padding: 4px 8px;
    border-radius: 20px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    opacity: 0;
    transition: opacity 0.3s;
  }
  
  .preview-area:hover .preview-actions {
    opacity: 1;
  }
  
  .upload-progress {
    margin-top: 10px;
    width: 200px;
  }
  
  /* 深色主题适配 */
  :deep(.el-upload) {
    width: 100%;
  }
  </style>