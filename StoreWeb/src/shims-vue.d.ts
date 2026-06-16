import type { Emitter } from 'mitt'
import type { BusEvents } from './utils/eventBus'

declare module 'vue' {
  interface ComponentCustomProperties {
    $bus: Emitter<BusEvents>
  }
}
export {}