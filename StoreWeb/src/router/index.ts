import { createRouter, createWebHashHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
import type { App } from 'vue'
import { Layout, getParentLayout } from '@/utils/routerHelper'
import { useI18n } from '@/hooks/web/useI18n'
import { NO_RESET_WHITE_LIST } from '@/constants'

const { t } = useI18n()

export const constantRouterMap: AppRouteRecordRaw[] = [
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard/analysis',
    name: 'Root',
    meta: {
      hidden: true
    }
  },
  {
    path: '/redirect',
    component: Layout,
    name: 'RedirectWrap',
    children: [
      {
        path: '/redirect/:path(.*)',
        name: 'Redirect',
        component: () => import('@/views/Redirect/Redirect.vue'),
        meta: {}
      }
    ],
    meta: {
      hidden: true,
      noTagsView: true
    }
  },
  {
    path: '/login',
    component: () => import('@/views/Login/Login.vue'),
    name: 'Login',
    meta: {
      hidden: true,
      title: t('router.login'),
      noTagsView: true
    }
  },
  {
    path: '/404',
    component: () => import('@/views/Error/404.vue'),
    name: 'NoFind',
    meta: {
      hidden: true,
      title: '404',
      noTagsView: true
    }
  },
  {
    path: '/403',
    component: () => import('@/views/Error/403.vue'),
    name: 'NoFind',
    meta: {
      hidden: true,
      title: '403',
      noTagsView: true
    }
  },
  {
    path: '/500',
    component: () => import('@/views/Error/500.vue'),
    name: 'NoFind',
    meta: {
      hidden: true,
      title: '500',
      noTagsView: true
    }
  }
]

export const asyncRouterMap: AppRouteRecordRaw[] = [
  {
    path: '/dashboard',
    component: Layout,
    redirect: '/dashboard/analysis',
    name: 'Dashboard',
    meta: {
      title: t('router.dashboard'),
      icon: 'vi-ant-design:home',
      alwaysShow: true
    },
    children: [
      {
        path: 'analysis',
        component: () => import('@/views/Dashboard/Analysis.vue'),
        name: 'Analysis',
        meta: {
          title: t('router.analysis'),
          noCache: true,
          affix: true
        }
      },
      {
        path: 'personal',
        component: () => import('@/views/Personal/PersonalCenter/PersonalCenter.vue'),
        name: 'personal',
        meta: {
          title: t('router.personalCenter'),
          noCache: true
        }
      }
    ]
  },

  {
    path: '/store',
    component: Layout,
    redirect: '/report/WR',
    name: 'store',
    meta: {
      title: '库存管理',
      icon: 'vi-tdesign:store',
      alwaysShow: true
    },
    children: [{
      path: 'WR',
      component: () => import('@/views/store/WR.vue'),
      name: 'WR',
      meta: {
        title: '入库单',
        noCache: false // 需要被缓存
      }
    },
    {
      path: 'DI',
      component: () => import('@/views/store/DI.vue'),
      name: 'DI',
      meta: {
        title: '直拨单'
      }
    },
    {
      path: 'WI',
      component: () => import('@/views/store/WI.vue'),
      name: 'WI',
      meta: {
        title: '领料单'
      }
    },
    {
      path: 'DT',
      component: () => import('@/views/store/DT.vue'),
      name: 'DT',
      meta: {
        title: '调拨单'
      }
    },
    {
      path: 'WT',
      component: () => import('@/views/store/WT.vue'),
      name: 'WT',
      meta: {
        title: '移库单'
      }

    },
    {
      path: 'IL',
      component: () => import('@/views/store/IL.vue'),
      name: 'IL',
      meta: {
        title: '报损单'
      }

    },
    {
      path: 'DC',
      component: () => import('@/views/store/DC.vue'),
      name: 'DC',
      meta: {
        title: '耗用单'
      }

    },
    {
      path: 'SA',
      component: () => import('@/views/store/SA.vue'),
      name: 'SA',
      meta: {
        title: '销售单'
      }
    },

    ]
  },
  {
    path: '/pd',
    component: Layout,
    redirect: '/pd/IC',
    name: 'pd',
    meta: {
      title: '盘点管理',
      icon: 'vi-tdesign:system-code',
      alwaysShow: true
    },
    children: [
      {
        path: 'pdic',
        component: () => import('@/views/pd/IC.vue'),
        name: 'pdic',
        meta: {
          title: '盘点单'
        }
      },
      {
        path: 'pdio',
        component: () => import('@/views/pd/IO.vue'),
        name: 'pdio',
        meta: {
          title: '盘盈单'
        }
      },
      {
        path: 'pdis',
        component: () => import('@/views/pd/IS.vue'),
        name: 'pdis',
        meta: {
          title: '盘亏单'
        }
      },
      {
        path: 'pdds',
        component: () => import('@/views/pd/DS.vue'),
        name: 'pdds',
        meta: {
          title: '盘存单'
        }
      },
      {
        path: 'pdstart',
        component: () => import('@/views/pd/start.vue'),
        name: 'pdstart',
        meta: {
          title: '盘点开关'
        }
      }
    ]
  },
  {
    path: '/action',
    component: Layout,
    redirect: '/action/trans',
    name: 'action',
    meta: {
      title: '事务管理',
      icon: 'vi-tdesign:transform',
      alwaysShow: true
    },
    children: [
      {
        path: 'actiontrans',
        component: () => import('@/views/action/trans.vue'),
        name: 'actiontrans',
        meta: {
          title: '事务查询'
        }
      },
      {
        path: 'actionstockbla',
        component: () => import('@/views/action/stockbla.vue'),
        name: 'actionstockbla',
        meta: {
          title: '结存查询'
        }
      },
    ]
  },
  {
    path: '/finance',
    component: Layout,
    redirect: '/finance/pay',
    name: 'finance',
    meta: {
      title: '财务管理',
      icon: 'vi-tdesign:money',
      alwaysShow: true
    },
    children: [
      {
        path: 'financear',
        component: () => import('@/views/finance/ar.vue'),
        name: 'financear',
        meta: {
          title: '应收明细'
        }
      },
      {
        path: 'financeap',
        component: () => import('@/views/finance/ap.vue'),
        name: 'financeap',
        meta: {
          title: '应付明细'
        }
      },
    ]
  },
  {
    path: '/acc',
    component: Layout,
    redirect: '/acc/time',
    name: 'acc',
    meta: {
      title: '会计设置',
      icon: 'vi-tdesign:money',
      alwaysShow: true
    },
    children: [
      {
        path: 'acctime',
        component: () => import('@/views/acc/time.vue'),
        name: 'acctime',
        meta: {
          title: '会计期间'
        }
      },
     
      {
        path: 'accused',
        component: () => import('@/views/acc/used.vue'),
        name: 'accused',
        meta: {
          title: '成本用途'
        }
      },
      {
				path: 'accytdz',
				component: () => import('@/views/acc/ytdz.vue'),
				name: 'accytdz',
				meta: {
					title: '用途对照'
				}
			},
      {
        path: 'accpaytype',
        component: () => import('@/views/acc/paytype.vue'),
        name: 'accpaytype',
        meta: {
          title: '应付账项'
        }
      }


    ]
  },

  {
    path: '/set',
    component: Layout,
    redirect: '/set/codes',
    name: 'set',
    meta: {
      title: '基础设置',
      icon: 'vi-tdesign:setting',
      alwaysShow: true
    },
    children: [
      {
        path: 'setcodes',
        component: () => import('@/views/set/codes.vue'),
        name: 'setcodes',
        meta: {
          title: '通用代码'
        }
      },
      {
				path: 'setitems',
				component: () => import('@/views/set/items.vue'),
				name: 'setitems',
				meta: {
					title: '物资编码'
				}
			},
			{
				path: 'setcusts',
				component: () => import('@/views/set/custs.vue'),
				name: 'setcusts',
				meta: {
					title: '供应商编码'
				}
			},
			{
				path: 'setsales',
				component: () => import('@/views/set/sales.vue'),
				name: 'setsales',
				meta: {
					title: '销售单位'
				}
			},
			{
				path: 'setstores',
				component: () => import('@/views/set/stores.vue'),
				name: 'setstores',
				meta: {
					title: '仓库/部门编码'
				}
			},
			{
				path: 'setcomm',
				component: () => import('@/views/set/comm.vue'),
				name: 'setcomm',
				meta: {
					title: '常用摘要'
				}
			},
			
			{
				path: 'setparam',
				component: () => import('@/views/set/param.vue'),
				name: 'setparam',
				meta: {
					title: '参数设置'
				}
			}


    ]
  },
  {
    path: '/report',
    component: Layout,
    redirect: '/report/list',
    name: 'report',
    meta: {
      title: '报表管理',
      icon: 'vi-tdesign:chart',
      alwaysShow: true
    },
    children: [
      {
        path: 'reportlist',
        component: () => import('@/views/report/list.vue'),
        name: 'reportlist',
        meta: {
          title: '仓库报表'
        }
      },
     
      {
        path: 'reportacc',
        component: () => import('@/views/report/acc.vue'),
        name: 'reportacc',
        meta: {
          title: '账务报表'
        }
      },

    ]
  },
  {
    path: '/users',
    component: Layout,
    redirect: '/users/udept',
    name: 'users',
    meta: {
      title: '用户管理',
      icon: 'vi-tdesign:user',
      alwaysShow: true
    },
    children: [
      {
        path: 'udept',
        component: () => import('@/views/users/udept.vue'),
        name: 'udept',
        meta: {
          title: '部门管理'
        }
      },
      {
        path: 'urole',
        component: () => import('@/views/users/role.vue'),
        name: 'urole',
        meta: {
          title: '角色管理'
        }
      },
      {
        path: 'usersrole',
        component: () => import('@/views/users/role.vue'),
        name: 'usersrole',
        meta: {
          title: '角色管理'
        }
      },
      {
        path: 'userslist',
        component: () => import('@/views/users/list.vue'),
        name: 'userslist',
        meta: {
          title: '用户列表'
        }
      },
      {
        path: 'userspower',
        component: () => import('@/views/users/power.vue'),
        name: 'userspower',
        meta: {
          title: '角色权限'
        }
      }

    ]
  },
  {
    path: '/log',
    component: Layout,
    redirect: '/log/type',
    name: 'log',
    meta: {
      title: '日志管理',
      icon: 'vi-eos-icons:role-binding',
      alwaysShow: true
    },
    children: [
      // {
      //   path: 'logtype',
      //   component: () => import('@/views/log/logtype.vue'),
      //   name: 'logtype',
      //   meta: {
      //     title: '日志分类'
      //   }
      // },
      {
        path: 'loglist',
        component: () => import('@/views/log/loglist.vue'),
        name: 'loglist',
        meta: {
          title: '日志列表'
        }
      },
      {
        path: 'report1',
        component: () => import('@/views/log/report1.vue'),
        name: 'report1',
        meta: {
          title: '报表test'
        }
      },
      {
        path: 'report2',
        component: () => import('@/views/log/report2.vue'),
        name: 'report2',
        meta: {
          title: '报表test2'
        }
      },

    ]
  }

]

const router = createRouter({
  history: createWebHashHistory(),
  strict: true,
  routes: constantRouterMap as RouteRecordRaw[],
  scrollBehavior: () => ({ left: 0, top: 0 })
})

export const resetRouter = (): void => {
  router.getRoutes().forEach((route) => {
    const { name } = route
    if (name && !NO_RESET_WHITE_LIST.includes(name as string)) {
      router.hasRoute(name) && router.removeRoute(name)
    }
  })
}

export const setupRouter = (app: App<Element>) => {
  app.use(router)
}

export default router
