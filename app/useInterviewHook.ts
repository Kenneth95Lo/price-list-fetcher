import NativeInterviewModule, {
  InterviewEventsEmitter,
  FeatureFlagMap,
  FEATUREFLAG_DATA_CHANGED_EVENT,
} from '../specs/NativeInterviewModule'
import {useCallback, useEffect, useState} from 'react'

// TODO: Implement the native module interface
// 1. Create a Turbo Module for price list fetching
// 2. Implement event emitter for feature flag changes
// 3. Add proper TypeScript types

export const useisEURSupportedFlagChange = () => {
  const [isEURSupported, setIsEURSupported] = useState<boolean | null>(null)

  useEffect(() => {
    // TODO: Implement feature flag subscription
    // 1. Subscribe to feature flag changes
    // 2. Update state when flag changes
    // 3. Clean up subscription on unmount
    const featureFlagSubscription = InterviewEventsEmitter.addListener(
      FEATUREFLAG_DATA_CHANGED_EVENT, (data: FeatureFlagMap) => {
        setIsEURSupported(data.supportEUR)
      }
    )

    return () => {
      featureFlagSubscription.remove()
    }
  }, [])

  return {
    isEURSupported,
  }
}

export const useFetchPriceList = (options: { [key: string]: string | number | boolean }) => {
  const [priceList, setPriceList] = useState<CryptoCurrency[]>([])
  const [error, setError] = useState<Error | null>(null)
  const [isLoading, setIsLoading] = useState<boolean>(false)

  useEffect(() => {
    let isMounted = true
    setIsLoading(true)
    setError(null)

    NativeInterviewModule?.fetchPriceList(options)
      .then((res) => {
        if (!isMounted) return
        switch (res?.type) {
          case 'success':
            setPriceList(res.data as CryptoCurrency[])
            break
          case 'error':
            setError(res.error)
            break
          default:
            setError(new Error('Unknown response type'))
        }
        setIsLoading(false)
      })
      .catch((err) => {
        if (isMounted) {
          setError(err)
          setIsLoading(false)
        }
      })

    return () => {
      isMounted = false
    }
  }, [options])

  return { priceList, error, isLoading }
}

export interface CryptoCurrency {
  id: number
  name: string
  usd: number
  eur?: number
  tags: string[]
}

// TODO: Implement price list normalization
// 1. Handle both price formats (USD-only and USD/EUR)
// 2. Add proper type checking where necessary