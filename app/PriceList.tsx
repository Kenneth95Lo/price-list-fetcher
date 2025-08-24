import React, { useState, useEffect, useCallback, useMemo } from 'react';
import {
  SafeAreaView,
  StyleSheet,
  Text,
  View,
  FlatList,
  TextInput,
  TouchableOpacity,
  StatusBar,
} from 'react-native';
import { CryptoCurrency, useFetchPriceList, useisEURSupportedFlagChange } from './useInterviewHook';
// Define the cryptocurrency data type

interface PriceData {
  code: string;
  data: CryptoCurrency[];
}

const PriceList: React.FC = () => {
  const { isEURSupported } = useisEURSupportedFlagChange();
  const options = useMemo(() => ({ isEuroSupported: isEURSupported ?? false }), [isEURSupported]);
  const { priceList, error, isLoading } = useFetchPriceList(options);
  const [cryptoData, setCryptoData] = useState<CryptoCurrency[]>([]);
  const [filteredData, setFilteredData] = useState<CryptoCurrency[]>([]);

  useEffect(() => {
    setCryptoData(priceList);
    setFilteredData(priceList);

  }, [priceList]);

  const renderErrorState = useCallback(() => {
    if (error) {
      return (
        <View style={{ padding: 10, backgroundColor: 'pink' }}>
          <Text style={{ color: 'red' }}>Error: {error.message}</Text>
        </View>
      )
    }
    return null;
  }, [error]);

  const renderLoaddingState = useCallback(() => {
    if (isLoading) {
      return <View><Text>Loading...</Text></View>
    }
    return null;
  }, [isLoading]);

  // Format the price based on its value
  const formatPrice = (price: number): string => {
    if (price >= 1) {
      // For values greater than or equal to 1, show up to 2 decimal places
      return price.toFixed(2);
    } else if (price >= 0.01) {
      // For values between 0.01 and 1, show up to 2 decimal places
      return price.toFixed(2);
    } else {
      // For very small values, show more decimal places as needed
      return price.toFixed(5);
    }
  };

  const renderEuroPrice = (item: CryptoCurrency) => {
    if (isEURSupported && item.eur !== undefined) {
      return <Text style={styles.priceText}>EUR: {formatPrice(item.eur)}</Text>;
    }
    return null;
  };

  // Render each cryptocurrency item
  const renderItem = useCallback(({ item }: { item: CryptoCurrency }) => (
    <View style={styles.itemContainer}>
      <Text style={styles.nameText}>{item.name}</Text>
      <Text style={styles.priceText}>USD: {formatPrice(item.usd)}</Text>
      {/* // TODO: extend to show EUR price if EUR is available */}
      {renderEuroPrice(item)}
      <View style={styles.separator} />
    </View>
  ), [isEURSupported]);

  const renderContent = () => {
    if (!isLoading && !error) {
      return (
        <FlatList
          data={filteredData}
          renderItem={renderItem}
          keyExtractor={(item) => item.id.toString()}
          style={styles.list}
          showsVerticalScrollIndicator={false}
          initialNumToRender={10}
          maxToRenderPerBatch={5}
          windowSize={11}
        />
      )
    }
  }

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" />
      {renderLoaddingState()}
      {renderErrorState()}
      {renderContent()}
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFFFFF',
  },
  searchContainer: {
    padding: 10,
    backgroundColor: '#F5F5F5',
  },
  searchInput: {
    height: 40,
    backgroundColor: '#FFFFFF',
    borderRadius: 10,
    paddingHorizontal: 15,
    fontSize: 16,
  },
  list: {
    flex: 1,
  },
  itemContainer: {
    paddingVertical: 8,
    paddingHorizontal: 16,
  },
  nameText: {
    fontSize: 18,
    color: '#000000',
  },
  priceText: {
    fontSize: 14,
    marginTop: 2,
    color: '#333333',
  },
  separator: {
    height: 0.5,
    backgroundColor: '#E5E5E5',
    marginTop: 8,
  }
});

export default React.memo(PriceList); 