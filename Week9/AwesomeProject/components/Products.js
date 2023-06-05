import { View, Text, ScrollView, TouchableOpacity } from "react-native";
import { useState, useEffect, useContext } from "react";
import React from "react";
import { getProducts } from "../api/products";
import { AppContext } from "../AppContext";

export default function Products() {
  const [products, setProducts] = useState([]);
  const { addToCart } = useContext(AppContext);

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
            <TouchableOpacity
              style={{
                backgroundColor: "#b70101",
                borderRadius: 4,
                paddingVertical: 8,
                paddingHorizontal: 12,
                alignItems: "center",
              }}
              onPress={() => addToCart(product)}
            >
              <Text>Add to Cart</Text>
            </TouchableOpacity>
          </View>
        ))}
      </ScrollView>
    </View>
  );
}
