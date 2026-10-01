<script setup lang="ts">
import { Head, useForm } from "@inertiajs/vue3"
import { onUnmounted, ref, watch } from "vue"
import ParticipantBar from "../../components/ParticipantBar.vue"
import { composeAuctionShow } from "../../../composition"
import { Money } from "../../../domain/money"

const props = defineProps<{
  auction: {
    id: string
    title: string
    current_price_cents: number
    ends_at: string
    open: boolean
  }
}>()

const price = ref(props.auction.current_price_cents)
const form = useForm({
  amount_cents: Money.fromCents(props.auction.current_price_cents).suggestedNext().cents,
})
const room = composeAuctionShow(props.auction.id, props.auction.current_price_cents, form, (cents) => {
  price.value = cents
})

watch(
  () => props.auction.current_price_cents,
  (cents) => room.applyServerPrice(cents),
)

function submit() {
  room.place(form.amount_cents)
}

onUnmounted(() => room.stop())
</script>

<template>
  <Head :title="auction.title" />
  <ParticipantBar />
  <main>
    <h1>{{ auction.title }}</h1>
    <p>Preço atual: <strong>{{ Money.fromCents(price).format() }}</strong></p>
    <p>{{ auction.open ? "Aberto" : "Encerrado" }} até {{ new Date(auction.ends_at).toLocaleString("pt-BR") }}</p>
    <form @submit.prevent="submit">
      <label>
        Lance (centavos)
        <input v-model.number="form.amount_cents" type="number" min="1" required />
      </label>
      <button type="submit" :disabled="form.processing">Enviar lance</button>
    </form>
  </main>
</template>
