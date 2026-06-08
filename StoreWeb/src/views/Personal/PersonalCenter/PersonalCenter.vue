<script setup lang="ts">
import { ContentWrap } from '@/components/ContentWrap'
import { ref, unref } from 'vue'
import { ElDivider, ElImage, ElTag, ElTabPane, ElTabs, ElButton, ElMessage } from 'element-plus'
import defaultAvatar from '@/assets/imgs/avatar.jpg'
import UploadAvatar from './components/UploadAvatar.vue'
import { Dialog } from '@/components/Dialog'
import EditInfo from './components/EditInfo.vue'
import EditPassword from './components/EditPassword.vue'
import { useUserStoreWithOut } from '@/store/modules/user'
import request from '@/axios'

const userStore = useUserStoreWithOut()

const userInfo = ref(userStore.userInfo)

const activeName = ref('first')

const dialogVisible = ref(false)

const uploadAvatarRef = ref<ComponentRef<typeof UploadAvatar>>()
const avatarLoading = ref(false)
const saveAvatar = async () => {
  try {
    avatarLoading.value = true
    const base64 = unref(uploadAvatarRef)?.getBase64()
    //console.log(base64)
    // 这里可以调用修改头像接口
    const res = await request.post({ url: '/api/file/upload-base64', data: { base64: base64 } })
    if (res.code === 0) {
      request.post({ url: '/api/users/setHeadImg', data: { headimg: res.url } })
      userInfo.value.headimg = res.url;      
      ElMessage.success('修改成功')

    }

    dialogVisible.value = false
  } catch (error) {
    console.log(error)
  } finally {
    avatarLoading.value = false
  }
}

const roles = ref([] as any[])
const rolesName = ref([] as string[])
const initData = async () => {
  const res = await request.post({ url: '/api/users/getRoles', data: {} })

  roles.value = res.data || []
  let roleIds = userInfo.value?.roles || []
  rolesName.value = roles.value.filter(o => roleIds.some(r => r === o.code)).map(item => item.name)

}

const refData = () => {
  userInfo.value = userStore.userInfo
}

initData()
</script>

<template>
  <div class="flex w-100% h-100%">
    <ContentWrap title="个人信息" class="w-400px">
      <div class="flex justify-center items-center">
        <div class="avatar w-[150px] h-[150px] relative cursor-pointer" @click="dialogVisible = true">
          <ElImage class="w-[150px] h-[150px] rounded-full" :src="userInfo?.headimg || defaultAvatar" fit="fill" />
        </div>
      </div>
      <ElDivider />
      <div class="flex justify-between items-center">
        <div>账号：</div>
        <div>{{ userInfo?.code }}</div>
      </div>
      <ElDivider />
      <div class="flex justify-between items-center">
        <div>昵称：</div>
        <div>{{ userInfo?.name }}</div>
      </div>
      <ElDivider />
      <div class="flex justify-between items-center">
        <div>手机号码：</div>
        <div>{{ userInfo?.tel ?? '-' }}</div>
      </div>
      <ElDivider />
      <div class="flex justify-between items-center">
        <div>用户邮箱：</div>
        <div>{{ userInfo?.email ?? '-' }}</div>
      </div>
      <ElDivider />
      <div class="flex justify-between items-center">
        <div>所属角色：</div>
        <div>
          <template v-if="rolesName.length">
            <ElTag v-for="item in rolesName" :key="item" class="ml-2 mb-w">{{ item }}
            </ElTag>
          </template>
          <template v-else>-</template>
        </div>
      </div>
      <ElDivider />
    </ContentWrap>
    <ContentWrap title="基本资料" class="flex-[3] ml-20px">
      <ElTabs v-model="activeName">
        <ElTabPane label="基本信息" name="first">
          <EditInfo :user-info="userInfo" @refData="refData" />
        </ElTabPane>
        <ElTabPane label="修改密码" name="second">
          <EditPassword />
        </ElTabPane>
      </ElTabs>
    </ContentWrap>
  </div>

  <Dialog v-model="dialogVisible" title="修改头像" width="800px">
    <UploadAvatar ref="uploadAvatarRef" :url="userInfo?.headimg || defaultAvatar" />

    <template #footer>
      <ElButton type="primary" :loading="avatarLoading" @click="saveAvatar"> 保存 </ElButton>
      <ElButton @click="dialogVisible = false">关闭</ElButton>
    </template>
  </Dialog>
</template>

<style lang="less" scoped>
.avatar {
  position: relative;

  &::after {
    position: absolute;
    top: 0;
    left: 0;
    display: flex;
    width: 100%;
    height: 100%;
    font-size: 50px;
    color: #fff;
    background-color: rgb(0 0 0 / 40%);
    border-radius: 50%;
    content: '+';
    opacity: 0;
    justify-content: center;
    align-items: center;
  }

  &:hover {
    &::after {
      opacity: 1;
    }
  }
}
</style>
