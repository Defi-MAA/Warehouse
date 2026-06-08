<script setup lang="ts">
import { Error } from '@/components/Error'
import { usePermissionStore } from '@/store/modules/permission'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/store/modules/user'
const { push } = useRouter()
const userStore = useUserStore()
const permissionStore = usePermissionStore()

const errorClick = () => {
 // userStore.logoutConfirm()
  push(permissionStore.addRouters[0]?.path as string)
}
</script>

<template>
  <Error @error-click="errorClick" />
</template>
