import { useFetchPriceList, useisEURSupportedFlagChange, CryptoCurrency } from "../../useInterviewHook";
import NativeInterviewModule from "../../../specs/NativeInterviewModule";
import { InterviewEventsEmitter } from "../../../specs/NativeInterviewModule";
import { renderHook } from "@testing-library/react-native";
import { act } from "react-test-renderer";

describe('useInterviewHook', () => {
    it('should have response upon successful fetch', async () => {
        const options = { isEuroSupported: true };
        const mockData = [
            { id: 0, name: 'BTC', usd: 888.88, eur: 999.99, tags: ['widthdrawal', 'deposit'] },
            { id: 1, name: 'ETH', usd: 888.88, eur: 999.99, tags: ['widthdrawal', 'deposit'] }
        ];
        jest.spyOn(NativeInterviewModule!, 'fetchPriceList').mockResolvedValue({
            type: 'success',
            data: mockData,
        });

        const { priceList, error, isLoading } = useFetchPriceList(options);

        expect(isLoading).toBe(true);
        expect(error).toBeNull();
        expect(priceList).toEqual([]);

        NativeInterviewModule?.fetchPriceList(options);

        expect(isLoading).toBe(false);
        expect(error).toBeNull();
        expect(priceList).toEqual(mockData);
        expect(priceList[0].eur).toBe(999.99);
    });

    it('should handle error upon failed fetch', async () => {
        const options = { isEuroSupported: true };
        const mockError = new Error('Failed to fetch');
        jest.spyOn(NativeInterviewModule!, 'fetchPriceList').mockRejectedValue(mockError);

        const { priceList, error, isLoading } = useFetchPriceList(options);

        expect(isLoading).toBe(true);
        expect(error).toBeNull();
        expect(priceList).toEqual([]);

        NativeInterviewModule?.fetchPriceList(options);

        expect(isLoading).toBe(false);
        expect(error).toEqual(mockError);
        expect(priceList).toEqual([]);
    });
})

describe('useisEURSupportedFlagChange', () => {
    jest.mock('../specs/NativeInterviewModule', () => ({
        FEATUREFLAG_DATA_CHANGED_EVENT: 'featureFlagDataChanged',
        InterviewEventsEmitter: {
            addListener: jest.fn(),
        },
    }));

    let listenerCallback;

    (InterviewEventsEmitter.addListener as jest.Mock).mockImplementation((eventName, callback) => {
        listenerCallback = callback;
        return {
            remove: jest.fn(),
        };
    });

    beforeEach(() => {
        jest.clearAllMocks();
    });

    test('should see ', () => {
        const { result } = renderHook(() => useisEURSupportedFlagChange());

        expect(result.current.isEURSupported).toBeNull();
    });

    test('should update isEURSupported state when a feature flag event is emitted', () => {
        const { result } = renderHook(() => useisEURSupportedFlagChange());
        act(() => {
            listenerCallback({ supportEUR: true });
        });
        expect(result.current.isEURSupported).toBe(true);
        act(() => {
            listenerCallback({ supportEUR: false });
        });
        expect(result.current.isEURSupported).toBe(false);
    });

    test('should clean up the subscription on unmount', () => {
        const mockRemove = jest.fn();
        (InterviewEventsEmitter.addListener as jest.Mock).mockReturnValue({ remove: mockRemove });

        const { unmount } = renderHook(() => useisEURSupportedFlagChange());
        unmount();

        expect(mockRemove).toHaveBeenCalledTimes(1);
    });

});

