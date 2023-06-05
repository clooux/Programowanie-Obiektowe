import { View, Text, ScrollView } from "react-native";
import { useState, useEffect } from "react";
import React from "react";
import { getProducts } from "../api/products";

export default function Products() {
  const [products, setProducts] = useState([]);

  useEffect(() => {
    setProducts(getProducts());
  }, []);

  return (
    <View style={{ flex: 1, flexDirection: "column", marginTop: 20 }}>
      <ScrollView
        contentContainerStyle={{
          alignItems: "center",
          justifyContent: "center",
        }}
        style={{ flex: 1 }}
      >
        {products.map((product) => (
          <View
            style={{
              backgroundColor: "#ffffff",
              padding: 20,
              marginBottom: 20,
              paddingHorizontal: 50,
            }}
            key={product.Id}
          >
            <Text>{product.Name}</Text>
            <Text>Price: {product.Price}</Text>
          </View>
        ))}
      </ScrollView>
    </View>
  );
}
